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
        
        var id: String {
            return user.userId
        }
        
        mutating func resetInfo(user: User) {
            self.user = user
        }
    }
    
    struct User: Codable {
        let userId: String
        let userNickname: String
        let userAvatar: String?
    }
}
