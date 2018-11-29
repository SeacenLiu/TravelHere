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
        let validatedPhone: Driver<Bool>
        let sendPhone: Driver<SimpleResult>
        
        init(input:(phone: Driver<String>, sendTaps: Signal<()>)) {
            validatedPhone = input.phone.map { $0.count == 11 }
            
            let provider = MoyaProvider<MyService.User>()
            sendPhone = input.sendTaps.withLatestFrom(input.phone).flatMapLatest({
                return  provider.rx.request(.sendSecurityCode(phoneNum: $0))
                    .map { response in
                        guard let responseData = response.mapObject(type: String.self) else {
                            return SimpleResult.defaultFailed
                        }
                        if responseData.code == .frequently {
                            return .failed(error: .operationFrequently)
                        }
                        return .ok(message: "操作成功")
                    }
                    .asDriver(onErrorJustReturn: SimpleResult.defaultFailed)
                    .startWith(.sending)
            })
        }
    }
}
