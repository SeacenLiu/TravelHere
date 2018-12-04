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
import Kingfisher

extension Account.Edit {
    final class ViewModel {
        let done: Driver<Bool>
        let validateName: Driver<Bool>
        let avatar: Driver<UIImage>
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
                .debug()
            
            done = modify
                .flatMapFirst {
                    provider.rx
                        .request(.modify(name: $0.0, avatar: $0.1))
                        .map(NetworkResponse<Account.User>.self)
                        .map({ response in
                            Account.Manager.shared.modifyUserInfo(with: response.data)
                            return response.code == .success
                        })
            }
                .asDriver(onErrorJustReturn: false)
            
            validateName = input.name.map { $0 != "" }
            
            let user = Account.Manager.shared.user
            name = Observable
                .just(user?.userNickname ?? "")
                .asDriver(onErrorJustReturn: "")
            
            let startImgObservable = KingfisherControl
                .getImage(
                    with: user?.userAvatar ?? "",
                    placeholder: "big_user_icon")
                .asObservable()
            let changemgObservable = input.avatar.asObservable()
            let concat = Observable
                .concat([
                    startImgObservable,
                    changemgObservable])
            avatar = concat
                .debug()
                .asDriver(onErrorJustReturn: UIImage(named: "big_user_icon")!)
        }
    }
}
