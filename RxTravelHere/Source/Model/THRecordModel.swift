//
//  THRecordModel.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/26.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation

/// 留言类型
enum THRecordType: Int, Codable {
    case heart = 0
    case note
    case blackboard
}

struct THRecordModel: Codable {
    let th_user: Account.User?
    var message: RecordModel
    
    init(user: Account.User, record: RecordModel) {
        th_user = user
        message = record
    }
    
    init(record: RecordModel) {
        th_user = nil
        message = record
    }
    
    // MARK: - 只读属性
    /// 评论只读属性
    var comments: [THCommentModel] {
        return message.th_comments ?? []
    }
    
    /// 用户的只读属性
    var user: Account.User {
        return th_user ?? Account.Manager.shared.user!
    }
    
    var id: Int {
        return message.id
    }
    
    var locationStr: String {
        return message.locationStr
    }
    
    var time: String {
        return Date.th_date(time: message.th_time).th_dateDescription
    }
    
    var type: THRecordType {
        return message.type
    }
    
    var text: String {
        return message.text
    }
    
    var imageUrl: String? {
        return message.imageUrl
    }
    
    /// 经纬度只读属性
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: message.latitude, longitude: message.longitude)
    }
    
    /// 获取首次评论
    public mutating func setComment(comments: [THCommentModel]) {
        message.th_comments = comments
    }
    
    /// 添加评论
    public mutating func addComment(comment: THCommentModel) {
        if message.th_comments == nil {
            message.th_comments = [THCommentModel]()
        }
        message.th_comments!.insert(comment, at: 0)
    }
    
    /// 根据索引获取评论
    public func comment(at idx: Int) -> THCommentModel? {
        guard let comments = message.th_comments else { return nil }
        return comments[idx]
    }
    
    
    /// 回复功能的模型处理
    public mutating func replyComment(text: String, at idx: Int) {
        guard message.th_comments?[idx] != nil else { fatalError("评论数组越界") }
        message.th_comments![idx].reply(text: text)
    }
    
    /// 修改经纬度
    public mutating func fixLocation(location: CLLocationCoordinate2D) {
        message.longitude = location.longitude
        message.latitude = location.latitude
    }
    
    enum CodingKeys: String, CodingKey {
        case th_user = "user"
        case message
    }
}

extension RecordModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "messageId"
        case type = "modelId"
        case longitude = "messageLongitude"
        case latitude = "messageLatitude"
        case text = "messageContent"
        case th_time = "messageTime"
        case imageUrl = "messageImage"
        case userId
        case locationStr = "messageAddress"
        case th_comments
    }
}

extension THRecordModel: Equatable {
    static func == (lhs: THRecordModel, rhs: THRecordModel) -> Bool {
        return lhs.message.id == rhs.message.id
    }
}

extension THRecordModel: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}

struct RecordModel {
    let id: Int
    let userId: String
    let type: THRecordType
    var longitude: Double
    var latitude: Double
    let text: String
    let th_time: Int
    let imageUrl: String?
    let locationStr: String
    
    var th_comments: [THCommentModel]?
}

