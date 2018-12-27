//
//  Record.Reply.ViewModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/27.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import Moya
import SVProgressHUD
import Kingfisher

extension Record.Reply {
    internal class ViewModel {
        
        let successHandle: (String) -> ()
        
        let userAvatar: Resource?
        let userNickname: String
        let time: String
        let content: String
        private let id: Int
        
        init(with comment: Comment.Model, handle: @escaping (String) -> ()) {
            userAvatar = comment.avatarResource
            userNickname = comment.userNickname
            time = comment.time
            content = comment.text
            id = comment.detail.id
            successHandle = handle
        }
        
        public func sendReply(with replyText: String, completion: @escaping ()->()) {
            SVProgressHUD.show(withStatus: "正在发送")
            let provider = MoyaProvider<Comment.NetworkTarget>()
            provider.request(.replyComment(commentId: id, commentReplyContent: replyText)) {
                (result) in
                switch result {
                case let .success(response):
                    if let network = try? response.map(NetworkResponse<String>.self),
                        network.code == .success {
                        SVProgressHUD.showSuccess(status: "回复成功")
                        completion()
                        self.successHandle(replyText)
                    } else {
                        SVProgressHUD.showError(status: "回复失败")
                    }
                case .failure(_):
                    SVProgressHUD.showError(status: "回复失败")
                }
            }
        }
    }
}
