//
//  Account.Manager.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/23.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Account {
    class Manager {
        public static let shared = Manager()
        
        private(set) var user: User? {
            didSet {
                guard let user = user else { fatalError("用户为空") }
                name.onNext(user.userNickname)
                KingfisherControl
                    .getImage(with: user.userAvatar ?? "", placeholder: "unlogin_avator")
                    .subscribe(onNext: { (image) in
                        self.avatar.accept(image)
                    })
                    .disposed(by: _disposeBag)
            }
        }
        
        private(set) var token: String?
        
        let _disposeBag = DisposeBag()
        let name = BehaviorSubject<String>(value: "")
        let avatar = BehaviorRelay<UIImage>(value: UIImage(named: "unlogin_avator")!)
        
        var isLogin: Bool {
            return user != nil && token != nil
        }
        
        private var model: Model? {
            if let user = user, let token = token {
                return Model(user: user, token: token)
            } else {
                return nil
            }
        }
        
        /// 登录
        public func login(with model: Model) {
            // 设置存储属性
            token = model.token
            user = model.user
            // 持久化数据
            UserDefaults.account = model
            UserDefaults.standard.synchronize()
        }
        
        /// 自动登录
        public func autoLogin() {
            if let model = UserDefaults.account {
                token = model.token
                user = model.user
            }
        }
        
        /// 注销
        public func logout() {
            token = nil
            user = nil
            UserDefaults.removeUserInfo()
        }
        
        /// 修改信息
        public func modifyUserInfo(with user: User) {
            self.user = user
            UserDefaults.account = model
            UserDefaults.standard.synchronize()
        }
        
        private init() {}
        
        private let accountFile = "useraccount"
    }
}

extension Account.Manager {
    func ensureLogin(curVC: UIViewController, handle: () -> ()) {
        if isLogin {
            handle()
        } else {
            curVC.present(Account.View(), animated: true)
        }
    }
}
