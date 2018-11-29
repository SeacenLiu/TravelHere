//
//  MyService.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import Moya

enum SimpleResult {
    case ok(message: String)
    case sending
    case failed(error: THError)
    
    static var defaultFailed: SimpleResult {
        return .failed(error: .networkAnomaly)
    }
}

enum MyService {
    static var baseURL = "http://119.23.47.182:9080"
    
    enum User {
        case sendSecurityCode(phoneNum: String)
    }
}

extension Response {
    func mapObject<T: Decodable>(type: T.Type) -> MyService.ResponseBody<T>? {
        return try? JSONDecoder().decode(MyService.ResponseBody<T>.self, from: data)
    }
}
