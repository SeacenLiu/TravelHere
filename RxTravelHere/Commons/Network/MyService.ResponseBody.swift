//
//  MyService.ResponseBody.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

extension MyService {
    /// 标准返回响应体
    struct ResponseBody<T: Decodable>: Decodable {
        let code: Statuscode
        let data: T
        let info: String
    }
    
    /// 图片信息响应体
    struct ImageInfo: Decodable {
        let path: String
    }
}
