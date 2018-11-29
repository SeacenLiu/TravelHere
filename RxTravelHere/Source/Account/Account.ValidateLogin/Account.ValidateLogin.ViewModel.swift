//
//  ViewModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

extension Account.ValidateLogin {
    final class ViewModel {
        typealias Result = SimpleResult<Account.Model>
        
        let validatedCode: Driver<Bool>
        let login: Driver<Result>
        
        init(phone: String, input:(code: Driver<String>, loginTaps: Signal<()>)) {
            validatedCode = input.code.map { $0.count == 4 }
            
            let provider = MoyaProvider<MyService.User>()
            login = input.loginTaps
                .withLatestFrom(input.code)
                .flatMapLatest({
                    return  provider.rx.request(.sendSecurityCode(phoneNum: $0))
                        .map { response -> Result in
                            guard let body = response.mapObject(type: Account.Model.self) else {
                                return .defaultFailed
                            }
                            if body.code != .success {
                                return .failed(error: .securityCodeError)
                            }
                            // FIXME: - 不应该将 Model 传出，那我的 Model 应该如何处理    
                            return .ok(data: body.data, msg: "登录成功")
                        }
                        .asDriver(onErrorJustReturn: .defaultFailed)
                        .startWith(.sending)
                })
        }
    }
}
