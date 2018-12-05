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
            saveUserInfo()
        }
        
        /// 自动登录
        public func autoLogin() {
            loadUserInfo()
        }
        
        /// 注销
        public func logout() {
            token = nil
            user = nil
            deleteUserInfo()
        }
        
        /// 修改信息
        public func modifyUserInfo(with user: User) {
            self.user = user
            saveUserInfo()
        }
        
        private init() {}
        
        private let accountFile = "useraccount"
    }
}

// MARK: - 用户信息增删改查
extension Account.Manager {
    /// 保存用户信息到沙盒目录中
    private func saveUserInfo() {
        guard let model = model else {
            fatalError("没有用户数据")
        }
        let encoder = JSONEncoder()
        let data = try! encoder.encode(model) as NSData
        let filePath = getDocPath(name: accountFile)
        data.write(toFile: filePath, atomically: true)
    }
    
    /// 获取用户信息
    private func loadUserInfo() {
        let filePath = getDocPath(name: accountFile)
        guard let data = NSData(contentsOfFile: filePath),
            let model = try? JSONDecoder().decode(
                Account.Model.self,
                from: data as Data) else {
                    return
        }
        token = model.token
        user = model.user
    }
    
    /// 删除用户信息
    private func deleteUserInfo() {
        let filePath = getDocPath(name: accountFile)
        try? FileManager.default.removeItem(atPath: filePath)
    }
    
    /// 获取沙盒路径
    private func getDocPath(name: String) -> String {
        let docPath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true)[0] as NSString
        return docPath.strings(byAppendingPaths: [name])[0]
    }
}
