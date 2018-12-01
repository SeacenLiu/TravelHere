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
        let sendPhone: Single<String>
        
        init(input:(phone: Driver<String>, sendTaps: Signal<()>)) {
            validatedPhone = input.phone.map { $0.count == 11 }
            
            sendPhone = input.sendTaps
                .withLatestFrom(input.phone)
                .flatMapLatest {
                    return MoyaProvider<MyService.User>.rx
                        .sc_request(String.self, .sendSecurityCode(phoneNum: $0))
            }
        }
    }
}
