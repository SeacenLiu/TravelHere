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
        let name: Driver<String>
        let avatar: Driver<UIImage>
        let validateName: Driver<Bool>
        let done: Driver<Bool>
        
        init(input:(avatar: Driver<UIImage>, name: Driver<String>, doneTaps: Signal<()>)) {
            let imageProvider = MoyaProvider<FileNetworkTarget>()
            let provider = MoyaProvider<Account.NetworkTarget>()
            
            name = Account.Manager.shared.name.asDriver(onErrorJustReturn: "")
            avatar = Observable
                .merge(
                    Account.Manager.shared.avatar.asObservable(),
                    input.avatar.asObservable()
                )
                .asDriver(onErrorJustReturn: UIImage(named: "big_user_icon")!)
            
            validateName = input.name.map { $0 != "" }
            
            done = input.doneTaps
                .debug()
                .withLatestFrom(avatar)
                .map {$0.imageJpgData!}
                .flatMapFirst { data -> Driver<NetworkValid<String>> in
                    imageProvider.rx
                        .request(FileNetworkTarget(data))
                        .map(NetworkResponse<ImageInfo>.self)
                        .map { .success(value: $0.data.path) }
                        .asDriver(onErrorJustReturn: .failure)
                }
                .flatMapFirst { result -> Driver<Bool> in
                    switch result {
                    case let .success(imagePath):
                        return input.name
                            .flatMapLatest { name in
                                provider.rx
                                    .request(.modify(name: name, avatar: imagePath))
                                    .map(NetworkResponse<Account.User>.self)
                                    .do(onSuccess: { Account.Manager.shared.modifyUserInfo(with: $0.data) })
                                    .map { $0.code == .success }
                                    .asDriver(onErrorJustReturn: false)
                        }
                    case .failure:
                        return Driver<Bool>.just(false)
                    }
            }
        }
        
        deinit {
            log("Edit ViewModel deinit.")
        }
    }
}


