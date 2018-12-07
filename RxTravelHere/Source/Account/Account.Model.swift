//
//  Account.Model.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

extension Account {
    struct Model: Codable {
        var user: User
        let token: String
    }
    
    struct User: Codable {
        let userId: String
        let userNickname: String
        let userAvatar: String?
    }
}

extension Account {
    class Manager {
        public static let shared = Manager()
        
        private(set) var user: User?
        
        private(set) var token: String?
        
        private var model: Model? {
            if let user = user, let token = token {
                return Model(user: user, token: token)
            } else {
                return nil
            }
        }
        
        /// 登录
        public func login(with model: Model) {
            token = model.token
            user = model.user
            UserDefaults.account = model
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
        }
        
        private init() {}
        
        private let accountFile = "useraccount"
    }
}
