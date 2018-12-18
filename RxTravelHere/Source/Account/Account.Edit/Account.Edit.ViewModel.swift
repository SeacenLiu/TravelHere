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
                .asDriver(onErrorJustReturn: UIImage(named: "big_user_icon")!).debug()
            
            validateName = input.name.map { $0 != "" }
            
            let imageUpload = input.doneTaps
                .debug()
                .withLatestFrom(avatar)
                .asObservable()
                .map {$0.imageJpgData!}
                .flatMapFirst {
                    imageProvider.rx
                        .request(FileNetworkTarget($0))
                        .do(onSuccess: { (res) in
                            log(String(data: res.data, encoding: .utf8)!)
                        },onError: { (err) in
                            log(err)
                        })
                        .map(NetworkResponse<ImageInfo>.self)
                        .do(onSuccess: { (res) in
                            log(res)
                        },onError: { (err) in
                            log(err)
                        })
                        .map { $0.data.path }
                }
            
            // 出错不能Dispose
            // 出错要传出去
            
            done = Observable
                .combineLatest(
                    input.name.asObservable(),
                    imageUpload)
                .debug()
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
        }
    }
}
