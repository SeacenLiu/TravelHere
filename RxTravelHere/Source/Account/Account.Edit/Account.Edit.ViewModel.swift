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
        let name: Driver<String>
        let avatar: Driver<UIImage>
        let validateName: Driver<Bool>
        let done: Driver<Bool>
        
        init(input:(avatar: Driver<UIImage>, name: Driver<String>, doneTaps: Signal<()>)) {
            let imageProvider = MoyaProvider<FileNetworkTarget>()
            let provider = MoyaProvider<Account.NetworkTarget>()
            let user = Account.Manager.shared.user
            
            name = Observable
                .just(user?.userNickname ?? "")
                .asDriver(onErrorJustReturn: "")
            
            let startImgObservable = KingfisherControl
                .getImage(
                    with: user?.userAvatar ?? "",
                    placeholder: "big_user_icon")
            let changemgObservable = input.avatar.asObservable()
            avatar = Observable
                .concat([startImgObservable,changemgObservable])
                .asDriver(onErrorJustReturn: UIImage(named: "big_user_icon")!)
                .debug()
            
            validateName = input.name.map { $0 != "" }
            
            let imageUpload = input.doneTaps
                .withLatestFrom(avatar)
                .map {$0.imageJpgData!}
                .asObservable()
                .flatMapFirst {
                    imageProvider.rx
                        .request(FileNetworkTarget($0))
                        .map(NetworkResponse<ImageInfo>.self)
                        .do(onSuccess: { (res) in
                            log(res)
                        })
                        .map { $0.data.path }
                }
            
            done = Observable
                .combineLatest(
                    input.name.asObservable(),
                    imageUpload)
                .flatMapFirst {
                    provider.rx
                        .request(.modify(name: $0.0, avatar: $0.1))
                        .map(NetworkResponse<Account.User>.self).debug()
                        .map({ response in
                            Account.Manager.shared.modifyUserInfo(with: response.data)
                            return response.code == .success
                        })
                }
                .asDriver(onErrorJustReturn: false)
        }
    }
}
