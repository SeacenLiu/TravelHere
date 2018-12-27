//
//  Record.Reply.View.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/27.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

extension Record.Reply {
    internal class View: UIViewController {
        private let _disposeBag = DisposeBag()
        
        private let _viewModel: ViewModel
        
        init(with vm: ViewModel) {
            _viewModel = vm
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - UI Element
        private lazy var avatar = UIImageView(side: 52, img: "unlogin_avator")
        
        private lazy var nickLb = UILabel(text: self._viewModel.userNickname, systemFont: 18, textColor: #colorLiteral(red: 0.2235294118, green: 0.2274509804, blue: 0.2274509804, alpha: 1))
        
        private lazy var timeLb = UILabel(text: self._viewModel.time, systemFont: 12, textColor: #colorLiteral(red: 0.5215686275, green: 0.5254901961, blue: 0.5254901961, alpha: 1))
        
        private lazy var contentLb = UILabel(text: self._viewModel.content, systemFont: 16, textColor: #colorLiteral(red: 0.2235294118, green: 0.2274509804, blue: 0.2274509804, alpha: 1))
        
        private lazy var inputer = THInputView { [weak self] (reply) in
            guard let `self` = self else { return }
            self._viewModel.sendReply(with: reply) { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        private lazy var navBarView = NavBarView.naviBarView(with: self.navigationController)
    }
}

extension Record.Reply.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        inputer.isContinueShow = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputer.show(with: "回复: " + _viewModel.userNickname)
    }
    
    private func setupUI() {
        if let avatarResoure = _viewModel.userAvatar {
            avatar.kf.setImage(with: avatarResoure)
        }
        
        view.backgroundColor = .white
        
        view.addSubview(avatar)
        view.addSubview(nickLb)
        view.addSubview(timeLb)
        view.addSubview(contentLb)
        view.addSubview(navBarView)
        
        navBarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(navBarView.Height)
        }
        avatar.snp.makeConstraints { (make) in
            make.top.equalTo(navBarView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(52)
            make.width.equalTo(52)
        }
        nickLb.snp.makeConstraints { (make) in
            make.centerY.equalTo(avatar)
            make.left.equalTo(avatar.snp.right).offset(15)
            make.right.equalToSuperview().offset(-12)
        }
        timeLb.snp.makeConstraints { (make) in
            make.left.equalTo(nickLb)
            make.right.equalTo(nickLb)
            make.bottom.equalTo(avatar)
        }
        contentLb.snp.makeConstraints { (make) in
            make.left.equalTo(avatar)
            make.right.equalTo(nickLb)
            make.top.equalTo(avatar.snp.bottom).offset(10)
        }
    }
}
