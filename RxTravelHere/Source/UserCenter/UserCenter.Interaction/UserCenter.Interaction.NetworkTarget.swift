//
//  UserCenter.Interaction.NetworkTarget.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/21.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import Moya

extension UserCenter.Interaction {
    struct NetworkTarget {
        let page: Int
        let count: Int
    }
}

extension UserCenter.Interaction.NetworkTarget: NetworkTarget {
    var interface: NetworkInterface {
        return .interaction
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestParameters(
            parameters: ["page": page, "count": count],
            encoding: URLEncoding.queryString)
    }
}
