//
//  MyService.StatusCode.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

extension MyService {
    /// 状态码
    enum Statuscode: Int, Decodable {
        case success = 200
        case frequently = 400
        case authenticationError = 401
        case failed = 500
        
        init(rawValue: Int) {
            switch rawValue {
            case 200...299:
                self = .success
            case 400:
                self = .frequently
            case 401...499:
                self = .authenticationError
            default:
                self = .failed
            }
        }
    }
}
