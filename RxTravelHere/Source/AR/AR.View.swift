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
        
        // MARK: - show view relate
        private lazy var recordCardView = Record.Show.CardView()
        private lazy var dismissTap: UITapGestureRecognizer = {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissRecordTap(gesture:)))
            tap.isEnabled = false
            return tap
        }()
        private var isShowView = false {
            didSet {
                nodeTap.isEnabled = !isShowView
                let alpha: CGFloat = isShowView ? 0 : 1
                UIView.animate(withDuration: 0.25) {
                    self.backBtn.alpha = alpha
                    self.drawLb.alpha = alpha
                    self.drawBtn.alpha = alpha
                }
            }
        }
        private lazy var nodeTap = UITapGestureRecognizer(target: self, action: #selector(selectNodeTapAction(gesture:)))
        private var selectNode: THShowNode?
    }
}

extension AR.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAR()
        addGesture()
        bindingViewModel()
        
        backBtn.rx.tap.bind(to: rx.dismissAction).disposed(by: _dispoeBag)
        drawBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
            let editView = Record.Edit.View()
            editView.delegate = self
            self.present(editView, animated: true)
        }).disposed(by: _dispoeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runAR()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseAR()
        dissmissRecordTap(gesture: dismissTap)
    }
    
    private func bindingViewModel() {
        arView.session.rx.cameraDidChangeNormal
            .withLatestFrom(_viewModel.nodes)
            .drive(onNext: { [unowned self] nodes in
                log("加载...当前:\n\(nodes)")
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

extension AR.View: RecordEditViewDelegate {
    func recordEditViewDidPublish(v: Record.Edit.View, isSussess: Bool) {
        // 1> 重新设置 AR
        runAR()
        // 2> 弹框提示用户举起手机
        
        // 3> 发射模型
        
    }
}

// MARK: - gesture
private extension AR.View {
    @objc func dissmissRecordTap(gesture: UITapGestureRecognizer) {
        if isShowView {
            dismissRecordCardView()
            // 禁用dismiss手势
            gesture.isEnabled = false
            // 恢复被选中结点
            if let node = selectNode {
                node.unSelectAction()
            }
            selectNode = nil
        }
    }
    
    @objc func selectNodeTapAction(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: arView)
        let results = arView.hitTest(point, options: [SCNHitTestOption.boundingBoxOnly : true, SCNHitTestOption.firstFoundOnly: true])
        if let node = results.first?.node as? THShowNode {
            // 选中结点
            selectNode = node
            // 执行被结点被选中动画
            node.selectAction()
            // 显示留言视图
            showRecordCardView(with: node)
            // 开启dismiss手势
            dismissTap.isEnabled = true
            
            // 如果是新消息云 需要移除
//            if let cloud = node as? THCloudNode {
//                THRedPointManager.shared.readComment(cid: cloud.commentModel.id) {
//                    self.removeCloud()
//                    self.selectNode = nil
//                }
//            }
        }
    }
    
    func addGesture() {
        arView.addGestureRecognizer(nodeTap)
        arView.addGestureRecognizer(dismissTap)
    }
}

// MARK: - Related Record CardView
extension AR.View {
    func showRecordCardView(with node: THShowNode) {
        let vm = _viewModel.getRecordViewModel(with: node)
        recordCardView.config(with: vm)
        let horizontalMargin: CGFloat = 30
        let verticalMargin: CGFloat = 40
        let recordW = UIScreen.main.bounds.width - horizontalMargin * 2
        let recoedH = UIScreen.main.bounds.height - verticalMargin * 2
        let rect = CGRect(x: horizontalMargin, y: verticalMargin, width: recordW, height: recoedH)
        recordCardView.showView(frame: rect) {
            self.isShowView = true
        }
    }
    
    func dismissRecordCardView() {
        if isShowView {
            recordCardView.closeView {
                self.isShowView = false
            }
        }
    }
}

// MARK: - AR part
extension AR.View: ARSessionDelegate {
    /// 发射模型
//    func shotNode(with model: THRecordModel) {
//        let node = THBaseNode(with: model)
//        if let currentFrame = arView.session.currentFrame {
//            let cameratransform = SCNMatrix4(currentFrame.camera.transform)
//            node.transform = cameratransform
//            arView.scene.rootNode.addChildNode(node)
//
//            var translation = matrix_identity_float4x4
//            translation.columns.3.z = -2
//            let newTransform = SCNMatrix4Mult(SCNMatrix4(translation), cameratransform)
//
//            let animation = CAKeyframeAnimation(keyPath: "transform")
//            animation.values = [node.transform, newTransform]
//            animation.duration = 0.5
//            animation.isRemovedOnCompletion = false
//            animation.fillMode = CAMediaTimingFillMode.forwards
//            node.addAnimation(animation, forKey: "shot")
//
//            // 修改留言的经纬度
//            let aimNode = SCNNode()
//            aimNode.transform = newTransform
//            let aimPosition = aimNode.position
//            log("变化前的坐标: \(node.position)")
//            log("变化后的坐标: \(aimPosition)")
//            let newLocation = THPositionManager.shared.computeCoordinate2D(position: aimPosition)
//            THRecordStore.shared.fixRecordLocation(messageId: model.id, location: newLocation)
//        }
//    }
    
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
