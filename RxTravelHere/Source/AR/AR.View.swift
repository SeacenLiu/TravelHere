//
//  AR.View.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import ARKit
import RxSwift
import RxCocoa
import SVProgressHUD
import SnapKit

// TODO: - 引导用户扫平面后才出现结点
extension AR {
    internal class View: UIViewController {
        private let _dispoeBag = DisposeBag()
        private let _viewModel: ViewModel
        
        init(with vm: ViewModel) {
            self._viewModel = vm
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - UI Element
        private lazy var arView = ARSCNView(frame: view.bounds)
        private lazy var backBtn = UIButton(image: #imageLiteral(resourceName: "back_btn"))
        private lazy var drawBtn = UIButton(image: #imageLiteral(resourceName: "edit_big_btn"))
        private lazy var drawLb = UILabel(text: "留言", systemFont: 14.0, textColor: .white)
        private lazy var effectView = UIVisualEffectView(style: .light, frame: view.bounds)
        
        // MARK: - AR
        private lazy var configuration = ARWorldTrackingConfiguration(worldAlignment: .gravityAndHeading)
        
        private lazy var omniLightNode = THLightNode()
        
        private var isFirstShow = true
        private var isFirstNormal = true
        private var isRunning = false
    }
}

extension AR.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAR()
        bindingViewModel()
        
        backBtn.rx.tap.bind(to: rx.dismissAction).disposed(by: _dispoeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runAR()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseAR()
        // 隐藏弹框
//        dissmissRecordTap(gesture: dismissTap)
    }
    
    private func bindingViewModel() {
        arView.session.rx.cameraDidChangeNormal
            .withLatestFrom(_viewModel.nodes)
            .drive(onNext: { [unowned self] nodes in
                log("加载...")
                log("当前:\n\(nodes)")
                self.setupARNode(with: nodes)
            })
            .disposed(by: _dispoeBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .lightGray
        
        view.addSubview(arView)
        view.addSubview(backBtn)
        view.addSubview(drawBtn)
        view.addSubview(drawLb)
        
        arView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        drawLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaInsets.bottom).offset(-10)
        }
        drawBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(drawLb.snp.top).offset(-6)
            make.centerX.equalTo(drawLb)
        }
    }
}

extension AR.View: ARSessionDelegate {
    /// 设置 AR 留言结点
    func setupARNode(with nodes: [THShowNode]) {
        arView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        nodes.forEach { self.arView.scene.rootNode.addChildNode($0) }
    }
    
    /// 运行AR
    func runAR() {
        arView.session.run(configuration)
        isRunning = true
    }
    
    /// 暂停AR
    func pauseAR() {
        if !isRunning {
            arView.session.pause()
            isRunning = false
        }
    }
    
    /// 设置 AR
    func setupAR() {
        arView.automaticallyUpdatesLighting = true
        arView.session.delegate = self
        /// 添加光源
        arView.scene.rootNode.addChildNode(omniLightNode)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let camera = frame.camera
        omniLightNode.transform = SCNMatrix4(camera.transform)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        log("AR 出错了: \(error)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        log("AR 被打断了")
        arLimited()
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        log("AR 结束打断")
        arNormal()
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            log("notAvailable")
        case .limited(let reson):
            log("limited")
            switch reson {
            case .excessiveMotion:
                SVProgressHUD.showTip(status: "手机移动速度过快", duration: 2)
            case .initializing:
                if isFirstShow {
                    arLimited()
                    isFirstShow = false
                }
            case .insufficientFeatures:
                SVProgressHUD.showTip(status: "当前场景AR效果不佳", duration: 2)
            default:
                break
            }
        case .normal:
            log("normal")
            if isFirstNormal {
                SVProgressHUD.showTip(status: "环顾四周，寻找并点击物体即可查看留言", duration: 3)
                isFirstNormal = false
            }
            arNormal()
        }
    }
    
    /// AR 限制显示
    private func arLimited() {
        view.insertSubview(effectView, at: 1)
    }
    
    /// AR 恢复正常显示
    private func arNormal() {
        if view.subviews.contains(effectView) {
            UIView.animate(withDuration: 0.25, animations: {
                self.effectView.alpha = 0
            }) { (_) in
                self.effectView.removeFromSuperview()
                self.effectView.alpha = 1
            }
        }
    }
}
