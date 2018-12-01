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
        let sendPhone: Observable<(phone: String, info: String)>
        
        init(input:(phone: Driver<String>, sendTaps: Signal<()>)) {
            validatedPhone = input.phone.map { $0.count == 11 }
            
            /*
             情况：
             1. T - 获取验证码成功
             2. F - 获取验证码失败
             3. F - 操作频繁
             4. F - 网络异常
            */
            let provider = MoyaProvider<MyService.User>()
            sendPhone = input.sendTaps
                .withLatestFrom(input.phone)
                .asObservable()
                .flatMapLatest { num in
                    return provider.rx
                        .sc_request(String.self, .sendSecurityCode(phoneNum: num))
                        .map { (num, $0) }
            }
                .observeOn(MainScheduler.instance)
                .share()
        }
    }
}
