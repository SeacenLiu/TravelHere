//
//  Record.Model.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/5.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

extension Record {
    enum Style: Int, Codable {
        case heart = 0
        case note
        case blackboard
        
        var image: UIImage {
            switch self {
            case .heart:
                return #imageLiteral(resourceName: "map_heart")
            case .note:
                return #imageLiteral(resourceName: "map_note")
            case .blackboard:
                return #imageLiteral(resourceName: "map_blackboard")
            }
        }
    }
    
    struct Model: Codable {
        let user: Account.User?
        let detail: Detail
        
        enum CodingKeys: String, CodingKey {
            case user
            case detail = "message"
        }
    }
    
}

// MARK: - 留言详细
extension Record {
    struct Detail: Codable  {
        let id: Int
        let userId: String
        let type: Style
        var longitude: Double
        var latitude: Double
        let text: String
        let th_time: Int
        let imageUrl: String?
        let locationStr: String
        
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
        }
    }
}

extension Record.Detail: MyRecordRepresentable { }
