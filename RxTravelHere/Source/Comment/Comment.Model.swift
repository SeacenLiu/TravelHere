//
//  Comment.Model.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/21.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

extension Comment {
    struct Model: Codable {
        let user: Account.User
        var detail: Detail
        
        mutating func reply(text: String) {
            detail.reply = text
        }
        
        enum CodingKeys: String, CodingKey {
            case user
            case detail = "comment"
        }
    }
}

extension Comment {
    struct Detail: Codable {
        let id: Int
        let recordId: Int
        let userId: String
        let text: String
        let time: Int
        var reply: String?
        
        enum CodingKeys: String, CodingKey {
            case id = "commentId"
            case recordId = "messageId"
            case time = "commentTime"
            case text = "commentContent"
            case reply = "commentReplyContent"
            case userId
        }
    }
}

extension Comment.Detail: Equatable {
    static func==(lhs: Comment.Detail, rhs: Comment.Detail) -> Bool {
        return lhs.id == rhs.id
    }
}
