//
//  Record.Model.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/5.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import Kingfisher

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
        
        var contentImage: UIImage {
            switch self {
            case .heart:
                return #imageLiteral(resourceName: "heart_edit_img")
            case .note:
                return #imageLiteral(resourceName: "note_edit_img")
            case .blackboard:
                return #imageLiteral(resourceName: "blackboard_edit_img")
            }
        }
    }
    
    struct Model: Codable {
        let user: Account.User?
        var detail: Detail
        
        var id: Int {
            return detail.id
        }
        
        enum CodingKeys: String, CodingKey {
            case user
            case detail = "message"
        }
        
        static var empty: Model {
            return Model(user: nil, detail: .empty)
        }
        
        static func myRecordModel(with detail: Detail) -> Model {
            return Model(user: Account.Manager.shared.user, detail: detail)
        }
        
        var isEmpty: Bool {
            return user == nil && detail.isEmtpy
        }
        
        mutating func changeCoordinate(with newLocation: CLLocationCoordinate2D) {
            detail.latitude = newLocation.latitude
            detail.longitude = newLocation.longitude
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
        let time: Int
        let imageUrl: String?
        let locationStr: String
        
        enum CodingKeys: String, CodingKey {
            case id = "messageId"
            case type = "modelId"
            case longitude = "messageLongitude"
            case latitude = "messageLatitude"
            case text = "messageContent"
            case time = "messageTime"
            case imageUrl = "messageImage"
            case userId
            case locationStr = "messageAddress"
        }
        
        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        static var empty: Detail {
            return Detail(id: -1, userId: "", type: .blackboard, longitude: 0, latitude: 0, text: "加载中...", time: 0, imageUrl: nil, locationStr: "留言地点")
        }
        
        var isEmtpy: Bool {
            return id == -1
        }
    }
}

extension Record.Detail: Equatable {
    static func == (lhs: Record.Detail, rhs: Record.Detail) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Record.Detail: MyRecordRepresentable { }

extension Record.Model: RecordContentRepresentable {
    var userNickname: String {
        return user?.userNickname ?? "用户名"
    }
    
    var time: String {
        return Date.dateDescription(with: detail.time)
    }
    
    var content: String {
        return detail.text
    }
    
    var locationStr: String {
        return detail.locationStr
    }
    
    var avatarResource: Resource? {
        guard let urlStr = user?.userAvatar,
            let url = URL(string: urlStr) else {
            return nil
        }
        return url
    }
    
    var imageResource: Resource? {
        guard let urlStr = detail.imageUrl,
            let url = URL(string: urlStr) else {
                return nil
        }
        return url
    }
}
