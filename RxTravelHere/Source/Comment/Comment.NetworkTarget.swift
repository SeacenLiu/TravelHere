//
//  Comment.NetworkTarget.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/21.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import Moya

extension Comment {
    enum NetworkTarget {
        case myComment(page: Int, count: Int)
        case sendComment(messageId: Int, commentContent: String)
        case commentByRecord(messageId: Int, page: Int, count: Int)
        case replyComment(commentId: Int, commentReplyContent: String)
    }
}

extension Comment.NetworkTarget: NetworkTarget {
    var interface: NetworkInterface {
        switch self {
        case .myComment(_, _), .sendComment(_, _):
            return .comment
        case .commentByRecord(_, _, _):
            return .commentByRecord
        case .replyComment(_, _):
            return .replyComment
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myComment(_, _), .commentByRecord(_, _, _):
            return .get
        case .sendComment(_, _),.replyComment(_, _):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .myComment(page, count):
            return .requestParameters(
                parameters: ["page": page, "count": count],
                encoding: URLEncoding.queryString)
        case let .sendComment(messageId, commentContent):
            return .requestParameters(
                parameters: ["messageId": messageId,
                             "commentContent": commentContent],
                encoding: URLEncoding.queryString)
        case let .commentByRecord(messageId, page, count):
            return .requestParameters(
                parameters: ["messageId": messageId,
                             "page": page,
                             "count": count],
                encoding: URLEncoding.queryString)
        case let .replyComment(commentId, commentReplyContent):
            return .requestParameters(
                parameters: ["commentId": commentId,
                             "commentReplyContent": commentReplyContent],
                encoding: URLEncoding.queryString)
        }
    }
}
