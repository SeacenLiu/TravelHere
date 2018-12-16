//
//  NetworkPlugin.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/15.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import Moya
import Result

internal class NetworkDebugPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        log(request)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(value):
            log(value)
        case let .failure(err):
            log(err)
        }
    }
}
