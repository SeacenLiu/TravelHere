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
    struct SendCodeResult {
        let phone: String
        let msg: String
        let isValid: Bool
    }
    
    final class PhoneViewModel {
        let validatedPhone: Driver<Bool>
        let sendCode: Driver<SendCodeResult>
        
        init(input:(phone: Driver<String>, sendTaps: Signal<()>)) {
            validatedPhone = input.phone.map { $0.count == 11 }

            let provider = MoyaProvider<Account.NetworkTarget>()
            
            sendCode = input.sendTaps
                .withLatestFrom(input.phone)
                .flatMapFirst { num in
                    return provider.rx
                        .request(.sendSecurityCode(phone: num))
                        .map(NetworkResponse<String>.self)
                        .map { SendCodeResult(phone: num, msg: $0.data, isValid: $0.code == .success) }
                        .asDriver(onErrorJustReturn: SendCodeResult(phone: num, msg: "网络异常", isValid: false))
            }
        }
    }
    
    
}
