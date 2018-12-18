//
//  UserCenter.ViewModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/17.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension UserCenter {
    internal class ViewModel {
        let avatarImg: Driver<UIImage>
        let name: Driver<String>
        
        init() {
            avatarImg = Account.Manager.shared.avatar
                .asDriver(onErrorJustReturn: UIImage(named: "unlogin_avator")!)
            name = Account.Manager.shared.name
                .asDriver(onErrorJustReturn: "未登录")
        }
    }
}
