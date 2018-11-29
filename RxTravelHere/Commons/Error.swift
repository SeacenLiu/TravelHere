//
//  Error.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

enum THError: Error {
    case networkAnomaly
    case operationFrequently
    case securityCodeError
    case UnknowError
    
    var localizedDescription: String {
        switch self {
        case .networkAnomaly:
            return "网络异常"
        case .operationFrequently:
            return "操作频繁"
        case .securityCodeError:
            return "验证码错误"
        case .UnknowError:
            return "未知错误"
        }
    }
}
