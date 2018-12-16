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
    }
}

extension Record.NetworkTarget: NetworkTarget {
    var interface: NetworkInterface {
        return .arroundRecord
    }
    
    var method: Moya.Method {
        return .get
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
        }
    }
}
