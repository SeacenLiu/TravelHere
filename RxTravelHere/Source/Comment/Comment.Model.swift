//
//  Comment.Model.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/21.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import Kingfisher

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
        
        static var empty: Model {
            return Model(user: .empty, detail: .empty)
        }
        
        var isEmpty: Bool {
            return user == Account.User.empty || detail == Detail.empty
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
        
        static var empty: Detail {
            return Detail(id: -1, recordId: 0, userId: "", text: "", time: 0, reply: nil)
        }
    }
}

extension Comment.Detail: Equatable {
    static func==(lhs: Comment.Detail, rhs: Comment.Detail) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Comment.Model: CommentRepresentable {
    var userNickname: String {
        return user.userNickname
    }
    
    var time: String {
        return Date.dateDescription(with: detail.time)
    }
    
    var text: String {
        return detail.text
    }
    
    var avatarResource: Resource? {
        guard let urlStr = user.userAvatar,
            let url = URL(string: urlStr) else {
                return nil
        }
        return url
    }
    
    var reply: String? {
        return detail.reply
    }
    
    
}
