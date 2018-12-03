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
    struct ShowViewModel {
        let phoneNum: String
    }
    
    final class ViewModel {
        let validatedCode: Driver<Bool>
        let login: Driver<Bool>
        
        init(phone: String, input:(code: Driver<String>, loginTaps: Signal<()>)) {
            validatedCode = input.code.map { $0.count == 4 }
            
            let provider = MoyaProvider<Account.NetworkTarget>()
            
            login = input.loginTaps
                .withLatestFrom(input.code)
                .flatMapFirst {
                    provider.rx
                        .request(.login(phone: phone, code: $0))
                        .map(NetworkResponse<Account.Model>.self)
                        .map({
                            Account.Manager.shared.login(with: $0.data)
                            return $0.code == .success
                        }).asDriver(onErrorJustReturn: false)
            }
        }
    }
}
