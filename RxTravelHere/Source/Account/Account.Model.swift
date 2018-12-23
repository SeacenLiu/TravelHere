//
//  Account.Model.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

extension Account {
    @objc(_TtCO12RxTravelHere7Account5Model)class Model: NSObject, NSCoding, Codable {
        var user: User
        let token: String
        
        init(user: User, token: String) {
            self.user = user
            self.token = token
            super.init()
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(user, forKey: "user")
            aCoder.encode(token, forKey: "token")
        }
        
        required init?(coder aDecoder: NSCoder) {
            user = aDecoder.decodeObject(forKey: "user") as! Account.User
            token = aDecoder.decodeObject(forKey: "token") as! String
        }
    }
    
    @objc(_TtCO12RxTravelHere7Account4User)class User: NSObject, NSCoding, Codable {
        let userId: String
        let userNickname: String
        let userAvatar: String?
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(userId, forKey: "userId")
            aCoder.encode(userNickname, forKey: "userNickname")
            aCoder.encode(userAvatar, forKey: "userAvatar")
        }
        
        required init?(coder aDecoder: NSCoder) {
            userId = aDecoder.decodeObject(forKey: "userId") as! String
            userNickname = aDecoder.decodeObject(forKey: "userNickname") as! String
            userAvatar = aDecoder.decodeObject(forKey: "userAvatar") as? String
        }
    }
}
