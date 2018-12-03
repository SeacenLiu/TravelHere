//
//  NetworkModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/2.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

enum Statuscode: Int, Decodable {
    case success = 200
    case infoError = 400
    case authenticationError = 401
    case serverError = 500
    
    init(rawValue: Int) {
        switch rawValue {
        case 200...299:
            self = .success
        case 400:
            self = .infoError
        case 401...499:
            self = .authenticationError
        default:
            self = .serverError
        }
    }
}

// 标准响应体结构体
struct NetworkResponse<T: Decodable>: Decodable {
    let code: Statuscode
    let data: T
    var info: String
}

// 图片信息
struct ImageInfo: Decodable {
    let path: String
}
