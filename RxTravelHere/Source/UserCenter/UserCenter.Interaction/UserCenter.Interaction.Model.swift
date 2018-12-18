//
//  UserCenter.Interaction.Model.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/17.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

extension UserCenter.Interaction {
    struct Model: Codable {
        let status: Int
        let userNickname: String
        let messageId: Int
        let commentId: Int
        let messageAddress: String
        let commentContent: String
        let commentReplyContent: String?
        let commentReplyTime: Int
    }
}

extension UserCenter.Interaction.Model: Equatable {
    static func ==(
        lhs: UserCenter.Interaction.Model,
        rhs: UserCenter.Interaction.Model) -> Bool {
        return lhs.commentId == rhs.commentId
    }
}
