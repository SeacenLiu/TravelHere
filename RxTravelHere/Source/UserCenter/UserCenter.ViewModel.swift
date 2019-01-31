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
        let redPoints: Driver<[Int]>
        
        init() {
            avatarImg = Account.Manager.shared.avatar
                .asDriver(onErrorJustReturn: UIImage(named: "unlogin_avator")!)
            name = Account.Manager.shared.name
                .asDriver(onErrorJustReturn: "未登录")
            redPoints = THRedPointManager.shared.unread
                .map {[0, $0.count]}
                .asDriver(onErrorJustReturn: [0, 0])
        }
        
        deinit {
            log("UserCenter.ViewModel deinit.")
        }
    }
}
