//
//  NetworkInterface.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/2.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

enum NetworkInterface: String {
    // MARK: - user
    case sendSecurityCode = "/user/sendSecurityCode"
    case login = "/user/login"
    case userModify = "/user/modify"
    
    // MARK: - file
    case fileUpload = "/file/upload"
    
    // MARK: - message(record)
    case record = "/message"
    case arroundRecord = "/message/list"
    case oneRecord = "/message/one"
}
