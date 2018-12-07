//
//  THCommentModel.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/6/12.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation

struct THCommentModel: Codable {
    let user: Account.User
    var comment: Comment
    
    var id: Int {
        return comment.id
    }
    
    var time: String {
        return Date.th_date(time: comment.time).th_dateDescription
    }
    
    var text: String {
        return comment.text
    }
    
    var reply: String? {
        return comment.reply
    }
    
    mutating func reply(text: String) {
        comment.reply = text
    }
}

extension THCommentModel: Hashable {
    var hashValue: Int {
        return comment.id.hashValue
    }
}

extension THCommentModel: Equatable {
    static func == (lhs: THCommentModel, rhs: THCommentModel) -> Bool {
        return lhs.comment.id == rhs.comment.id
    }
}

struct Comment: Codable {
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

extension Comment: Equatable {
    static func==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }
}
