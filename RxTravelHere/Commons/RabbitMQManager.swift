//
//  RabbitMQManager.swift
//  RabbitMQDemo
//
//  Created by SeacenLiu on 2018/7/21.
//  Copyright © 2018年 SeacenLiu. All rights reserved.
//

import Foundation

class RabbitMQManager {
    static let shared = RabbitMQManager()
    
    private let uri = "amqp://guest:guest@119.23.47.182"
    
    private init() {}
    
    private var connection: RMQConnection?
    
    public func createCommentConnection(with userId: String) {
        let queue = "comment:\(userId)"
        creatNewConnection(queue: queue)
    }
    
    public func creatNewConnection(queue: String) {
        if let conn = connection {
            conn.close()
        }
        let delegate = RMQConnectionDelegateLogger()
        connection = RMQConnection(uri: uri, delegate: delegate)
        guard let conn = connection else { fatalError("连接为空") }
        conn.start()
        let ch = conn.createChannel()
        let q = ch.queue(queue, options: [.durable])
        
        q.subscribe({ m in
            if let message = String(data: m.body, encoding: String.Encoding.utf8) {
                log("Received: \(message)")
                // 1. 反序列化
                if let model = try? JSONDecoder().decode(Comment.Detail.self, from: m.body) {
                    log(model)
                    // 2. 使用 THRedPointManager addInteraction
                    THRedPointManager.shared.addComment(model: model)
                }
                
            } else {
                log("信息不合法")
            }
        })
    }
    
    public func cutConnection() {
        defer { connection = nil }
        if let conn = connection {
            conn.close()
        }
    }
    
}
