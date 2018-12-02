//
//  NetworkConfig.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/2.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import Moya

// MARK: - NetworkTarget
protocol NetworkTarget: TargetType {
    var interface: NetworkInterface { get }
}

extension NetworkTarget {
    var baseURL: URL { return URL(string: "http://119.23.47.182:9080")! }
    var sampleData: Data { return "{}".data(using: .utf8)! }
    var path: String { return self.interface.rawValue }
    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

// MARK: - Network
class Network<Target>: MoyaProvider<Target> where Target: NetworkTarget { }
