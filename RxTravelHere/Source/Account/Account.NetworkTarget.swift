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
        case modify(name: String, avatar: String)
    }
}

extension Account.NetworkTarget: NetworkTarget {
    var interface: NetworkInterface {
        switch self {
        case .sendSecurityCode(_):
            return .sendSecurityCode
        case .login(_, _):
            return .login
        case .modify(_, _):
            return .userModify
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendSecurityCode(_):
            return .get
        case .login(_, _):
            return .post
        case .modify(_, _):
            return .put
        }
    }
    
    // TODO: - 需要改进
    var task: Task {
        switch self {
        case let .sendSecurityCode(phone):
            return .requestParameters(parameters: ["phoneNum": phone], encoding: URLEncoding.queryString)
        case let .login(phone, code):
            return .requestParameters(parameters: ["phoneNum": phone, "code": code], encoding: URLEncoding.queryString)
        case let .modify(name, avatar):
            return .requestParameters(parameters: ["nickname": name, "avatar": avatar], encoding: URLEncoding.queryString)
        }
    }
    
}
