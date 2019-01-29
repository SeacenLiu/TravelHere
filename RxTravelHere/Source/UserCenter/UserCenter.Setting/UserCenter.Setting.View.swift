//
//  UserCenter.Setting.View.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2019/1/28.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SVProgressHUD

extension UserCenter.Setting {
    internal class View: UIViewController {
        private let _disposeBag = DisposeBag()
        private lazy var _viewModel = ViewModel(input: (
            avatar: self.contentView.avatarBtn.rx.tap
                .flatMap { [weak self] _ in
                    ImagePickerControl.showActionAndGetImage(from: self)
                }
                .filter {image in image != nil}
                .flatMap { [weak self] image in
                    ImageClipControl.cropImage(image!, hwRatio: 1, isCycle: true, from: self)
                }
                .do(onNext: { (_) in SVProgressHUD.show() })
                .asDriver(onErrorJustReturn: UIImage()),
            name: self.contentView.nameBtn.rx.tap.asDriver()
                .flatMap { [weak self] _ in
                    ActionAlertControl
                        .showWithTextField(from: self,
                                           title: "修改昵称",
                                           text: Account.Manager.shared.user?.userNickname)
                        .do(onNext: { (_) in SVProgressHUD.show() })
                        .asDriver(onErrorJustReturn: "无名氏")
        })
        )
        
        // MARK: - UI Element
        private lazy var navBarView = NavBarView.naviBarView(with: self.navigationController) { (bv) in
            bv.backTitle = " 个人设置"
            bv.barColor = .white
        }
        private lazy var exitBtn = UIButton(title: "退出登录", titleColor: .red, fontSize: 18.0)
        private lazy var contentView = ContentView()
    }
}

extension UserCenter.Setting.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        _viewModel.avatar.drive(contentView.avatarImgV.rx.image).disposed(by: _disposeBag)
        _viewModel.name.drive(contentView.nameLb.rx.text).disposed(by: _disposeBag)
        _viewModel.modifySuccess.drive(onNext: { [unowned self] success in
            if success {
                self.showHUD(successText: "修改成功")
            } else {
                self.showHUD(errorText: "修改失败")
            }
        }).disposed(by: _disposeBag)
        
        exitBtn.rx.tap.subscribe(onNext: { _ in
            log("退出操作")
        }).disposed(by: _disposeBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(navBarView)
        navBarView.addSubview(exitBtn)
        view.addSubview(contentView)
        
        navBarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(UIDevice.statusBarH + 44)
        }
        exitBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalTo(navBarView.backBtn)
        }
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(navBarView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension UserCenter.Setting {
    internal class ContentView: UIView {
        convenience init() { self.init(frame: .zero) }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        lazy var avatarBtn = UIButton(color: .clear)
        lazy var nameBtn = UIButton(color: .clear)
        
        lazy var avatarLb = UILabel(text: "头像", systemFont: 17.0, textColor: .darkText)
        lazy var avatarImgV = UIImageView(imageName: "unlogin_avator", radius: 25.0)
        lazy var arrowImgV = UIImageView(imageName: "right_arrow")
        lazy var line1 = UIView(color: #colorLiteral(red: 0.8939959407, green: 0.8940270543, blue: 0.9021738172, alpha: 1))
        lazy var nickTitleLb = UILabel(text: "昵称", systemFont: 17.0, textColor: .darkText)
        lazy var nameLb = UILabel(text: "无名氏", systemFont: 17.0, textColor: .darkText)
        lazy var line2 = UIView(color: #colorLiteral(red: 0.8939959407, green: 0.8940270543, blue: 0.9021738172, alpha: 1))
        
        func setupUI() {
            backgroundColor = .white
            addSubview(avatarBtn)
            addSubview(nameBtn)
            addSubview(avatarLb)
            addSubview(avatarImgV)
            addSubview(arrowImgV)
            addSubview(line1)
            addSubview(nickTitleLb)
            addSubview(nameLb)
            addSubview(avatarLb)
            addSubview(line2)
            avatarBtn.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.bottom.equalTo(line1)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
            avatarLb.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(24)
                make.left.equalToSuperview().offset(24)
            }
            arrowImgV.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-24)
                make.centerY.equalTo(avatarLb)
            }
            avatarImgV.snp.makeConstraints { (make) in
                make.centerY.equalTo(avatarLb)
                make.right.equalTo(arrowImgV.snp.left).offset(-30)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            line1.snp.makeConstraints { (make) in
                make.top.equalTo(avatarLb.snp.bottom).offset(24)
                make.left.equalToSuperview().offset(24)
                make.right.equalToSuperview().offset(-24)
                make.height.equalTo(0.5)
            }
            nameBtn.snp.makeConstraints { (make) in
                make.top.equalTo(line1)
                make.height.equalTo(68)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
            nickTitleLb.snp.makeConstraints { (make) in
                make.top.equalTo(line1).offset(24)
                make.left.equalToSuperview().offset(24)
            }
            nameLb.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-24)
                make.centerY.equalTo(nickTitleLb)
            }
            line2.snp.makeConstraints { (make) in
                make.top.equalTo(nickTitleLb.snp.bottom).offset(24)
                make.left.equalToSuperview().offset(24)
                make.right.equalToSuperview().offset(-24)
                make.height.equalTo(0.5)
            }
        }
    }
}
