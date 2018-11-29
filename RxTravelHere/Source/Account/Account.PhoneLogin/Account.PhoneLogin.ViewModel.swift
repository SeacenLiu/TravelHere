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

extension Account.PhoneLogin {
    final class PhoneViewModel {
        typealias Result = SimpleResult<String>
        
        let validatedPhone: Driver<Bool>
        let sendPhone: Driver<Result>
        
        init(input:(phone: Driver<String>, sendTaps: Signal<()>)) {
            validatedPhone = input.phone.map { $0.count == 11 }
            
            let provider = MoyaProvider<MyService.User>()
            sendPhone = input.sendTaps.withLatestFrom(input.phone).flatMapLatest({
                let phoneNum = $0
                return  provider.rx.request(.sendSecurityCode(phoneNum: phoneNum))
                    .map { response -> Result in
                        guard let body = response.mapObject(type: String.self) else {
                            return .defaultFailed
                        }
                        if body.code == .frequently {
                            return .failed(error: .operationFrequently)
                        }
                        return .ok(data: phoneNum, msg: "操作成功")
                    }
                    .asDriver(onErrorJustReturn: .defaultFailed)
                    .startWith(.sending)
            })
        }
    }
}
