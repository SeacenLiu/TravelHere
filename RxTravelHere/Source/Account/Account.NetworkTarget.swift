//
//  Account.Network.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/2.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import Moya

extension Account {
    enum NetworkTarget {
        case sendSecurityCode(phone: String)
        case login(phone: String, code: String)
    }
}

extension Account.NetworkTarget: NetworkTarget {
    var interface: NetworkInterface {
        switch self {
        case .sendSecurityCode(phone: _):
            return .sendSecurityCode
        case .login(phone: _, code: _):
            return .login
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendSecurityCode(phone: _):
            return .get
        case .login(phone: _, code: _):
            return .post
        }
    }
    
    // TODO: - 需要改进
    var task: Task {
        switch self {
        case let .sendSecurityCode(phone):
            return .requestParameters(parameters: ["phoneNum": phone], encoding: URLEncoding.queryString)
        case let .login(phone, code):
            return .requestParameters(parameters: ["phoneNum": phone, "code": code], encoding: URLEncoding.queryString)
        }
    }
    
}
