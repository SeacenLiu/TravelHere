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
        
        public func login(with model: Model) {
            user = model.user
            token = model.token
            // TODO: - 持久化
        }
        
        public func modifyUserInfo(with user: User) {
            self.user = user
            // TODO: - 持久化
        }
        
        private init() {}
    }
}
