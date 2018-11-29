//
//  ViewModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Account.ValidateLogin {
    final class ViewModel {
        let validatedCode: Driver<Bool>
        
        let login: Driver<Bool>
        
        init(input:(code: Driver<String>, loginTaps: Signal<()>)) {
            validatedCode = input.code.map { $0.count == 4 }
            login = input.loginTaps.withLatestFrom(input.code).flatMapLatest {
                Observable.just($0 == "1234").asDriver(onErrorJustReturn: false)
            }
        }
    }
}
