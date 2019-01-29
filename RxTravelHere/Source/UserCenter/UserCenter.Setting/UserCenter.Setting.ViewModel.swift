//
//  UserCenter.Setting.ViewModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2019/1/28.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

extension UserCenter.Setting {
    internal class ViewModel {
        // MARK: - Output
        let avatar: Driver<UIImage>
        let name: Driver<String>
        let modifySuccess: Driver<Bool>
        
        init(input:(avatar: Driver<UIImage>, name: Driver<String>)) {
            avatar = Driver.merge(
                Account.Manager.shared.avatar.asDriver(),
                input.avatar)
            name = Driver.merge(
                Account.Manager.shared.name
                    .asDriver(onErrorJustReturn: "无名氏"),
                input.name)
            
            let imageProvider = MoyaProvider<FileNetworkTarget>()
            let provider = MoyaProvider<Account.NetworkTarget>()
            let avatarSuccess = input.avatar.map { $0.imageJpgData! }
                .flatMapLatest { data -> Driver<NetworkValid<String>> in
                    imageProvider.rx
                        .request(FileNetworkTarget(data))
                        .map(NetworkResponse<ImageInfo>.self)
                        .map { .success(value: $0.data.path) }
                        .asDriver(onErrorJustReturn: .failure)
                }
                .debug()
                .flatMapLatest { result -> Driver<Bool> in
                    switch result {
                    case let .success(imagePath):
                        return provider.rx
                                    .request(.modify(
                                        name: Account.Manager.shared.user?.userNickname ?? "",
                                        avatar: imagePath))
                                    .map(NetworkResponse<Account.User>.self)
                                    .do(onSuccess: { Account.Manager.shared.modifyUserInfo(with: $0.data) })
                                    .map { $0.code == .success }
                                    .asDriver(onErrorJustReturn: false)
                    case .failure:
                        return Driver<Bool>.just(false)
                    }
            }.debug()
            let nameSuccess = input.name.flatMapLatest {
                provider.rx
                    .request(.modifyName(name: $0))
                    .map(NetworkResponse<Account.User>.self)
                    .do(onSuccess: { Account.Manager.shared.modifyUserInfo(with: $0.data) })
                    .map { $0.code == .success }
                    .asDriver(onErrorJustReturn: false)
            }
            modifySuccess = Driver.merge(avatarSuccess, nameSuccess).debug("success")
        }
    }
}
