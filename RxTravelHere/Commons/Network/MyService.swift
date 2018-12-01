//
//  MyService.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum SimpleResult<T> {
    case ok(data: T, msg: String)
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
        case login(phoneNum: String, code: String)
    }
}

extension Reactive where Base: MoyaProviderType {
    func sc_request<T: Decodable>(_ type: T.Type, _ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<T> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                case let .success(response):
                    do {
                        let body = try response.map(MyService.ResponseBody<T>.self)
                        // 处理业务错误
                        if body.code != .success {
                            single(.error(THError.infoEror(str: body.info)))
                        }
                        // 返回模型
                        single(.success(body.data))
                    } catch (_) {
                        // JSON反序列化错误
                        single(.error(THError.jsonError))
                    }
                case .failure(_):
                    // 处理网络异常错误
                    single(.error(THError.networkAnomaly))
                }
            }
            
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}
