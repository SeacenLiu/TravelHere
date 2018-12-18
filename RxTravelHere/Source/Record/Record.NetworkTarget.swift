//
//  Record.NetworkTarget.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/15.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import Moya

extension Record {
    enum NetworkTarget {
        case arroundRecord(longitude: Double, latitude: Double, distance: Double, page: Int, count: Int)
        case myRecord(page: Int, count: Int)
        case uploadRecord(messageContent: String, modelId: Int, messageLongitude: Double, messageLatitude: Double, messageImage: String, messageAddress: String)
        case modifyRecord(messageId: Int, messageLongitude: Double, messageLatitude: Double)
        case oneRecord(id: Int)
    }
}

extension Record.NetworkTarget: NetworkTarget {
    var interface: NetworkInterface {
        switch self {
        case .arroundRecord(_, _, _, _, _):
            return .arroundRecord
        case .oneRecord(_):
            return .oneRecord
        default:
            return .record
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .uploadRecord(_, _, _, _, _, _):
            return .post
        case .modifyRecord(_, _, _):
            return .put
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .arroundRecord(longitude, latitude, distance, page, count):
            return .requestParameters(
                parameters: [
                    "longitude": longitude,
                    "latitude": latitude,
                    "distance": distance,
                    "page": page,
                    "count": count
                ], encoding:  URLEncoding.queryString)
        case let .myRecord(page, count):
            return .requestParameters(
                parameters: [
                    "page": page,
                    "count": count
                ], encoding:  URLEncoding.queryString)
        case let .uploadRecord(messageContent, modelId, messageLongitude, messageLatitude, messageImage, messageAddress):
            return .requestParameters(
                parameters: [
                    "messageContent": messageContent,
                    "modelId": modelId,
                    "messageLongitude": messageLongitude,
                    "messageLatitude": messageLatitude,
                    "messageImage": messageImage,
                    "messageAddress": messageAddress
                ], encoding:  URLEncoding.queryString)
        case let .modifyRecord(messageId, messageLongitude, messageLatitude):
            return .requestParameters(
                parameters: [
                    "messageId": messageId,
                    "messageLongitude": messageLongitude,
                    "messageLatitude": messageLatitude,
                ], encoding:  URLEncoding.queryString)
        case let .oneRecord(id):
            return .requestParameters(
                parameters: [
                    "id": id
                    ], encoding:  URLEncoding.queryString)
        }
    }
}
