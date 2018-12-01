//
//  MyService.User.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import Moya

extension MyService.User: TargetType {
    var baseURL: URL { return URL(string: MyService.baseURL.appending("/user"))! }
    
    var path: String {
        switch self {
        case .sendSecurityCode(_):
            return "/sendSecurityCode"
        case .login(_, _):
            return "/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendSecurityCode(_):
            return .get
        case .login( _, _):
            return .post
        }
    }
    
    /// 用于单元测试
    var sampleData: Data {
        return "Half measures are as bad as nothing at all.".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case let .sendSecurityCode(phoneNum):
            return .requestParameters(parameters: ["phoneNum": phoneNum], encoding: URLEncoding.queryString)
        case let .login(phoneNum, code):
            return .requestParameters(parameters: ["phoneNum": phoneNum, "code": code], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var dataType: Decodable.Type {
        switch self {
        case .sendSecurityCode(_):
            return String.self
        case .login(_, _):
            return String.self
        }
    }
    
    
}
