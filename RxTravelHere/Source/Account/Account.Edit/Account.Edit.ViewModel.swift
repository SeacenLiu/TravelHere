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

extension Account.Edit {
    final class ViewModel {
        let done: Driver<Bool>
        let validateName: Driver<Bool>
        let avatar: Driver<String>
        let name: Driver<String>
        
        init(input:(avatar: Driver<UIImage>, name: Driver<String>, doneTaps: Signal<()>)) {
            let imageProvider = MoyaProvider<FileNetworkTarget>()
            let provider = MoyaProvider<Account.NetworkTarget>()
            
            let imageUpload = input.doneTaps
                .withLatestFrom(input.avatar)
                .map {$0.imageJpgData!}
                .asObservable()
                .flatMapFirst {
                    imageProvider.rx
                        .request(FileNetworkTarget($0))
                        .map(NetworkResponse<ImageInfo>.self)
                        .map { $0.data.path }
                }
            
            let modify = Observable
                .combineLatest(input.name.asObservable(), imageUpload)
                .asSignal(onErrorJustReturn: ("", ""))
            
            done = input.doneTaps
                .withLatestFrom(modify)
                .flatMapFirst {
                    provider.rx
                        .request(.modify(name: $0.0, avatar: $0.1))
                        .map(NetworkResponse<Account.User>.self)
                        .map({ response in
                            Account.Manager.shared.modifyUserInfo(with: response.data)
                            return response.code == .success
                        })
                        .asDriver(onErrorJustReturn: false)
            }
            
            validateName = input.name.map { $0 != "" }
            
            let user = Account.Manager.shared.user
            name = Observable
                .just(user?.userNickname ?? "")
                .asDriver(onErrorJustReturn: "")
            avatar = Observable
                .just(user?.userAvatar ?? "")
                .asDriver(onErrorJustReturn: "")
            
        }
    }
}
