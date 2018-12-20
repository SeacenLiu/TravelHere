//
//  UserCenter.MyRecord.ViewModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/18.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

extension UserCenter.MyRecord {
    internal class ViewModel {
        
        var data: Driver<[Record.Detail]>!
        var refreshStatus: Driver<RefreshStatus> {
            return _refreshStatus.asDriver(onErrorJustReturn: .InvalidData)
        }
        var hasContent: Driver<Bool> {
            return _hasContent.asDriver(onErrorJustReturn: false)
        }
        
        var _refreshStatus = PublishSubject<RefreshStatus>()
        var _hasContent = PublishSubject<Bool>()
        var _page = 1
        private var dataArray = [Record.Detail]()
        
        init(input: (refresh: Driver<()>, loadMore: Driver<()>)) {
            let provider = MoyaProvider<Record.NetworkTarget>()
            
            let refresh = Driver.merge(input.refresh, Driver.of(()))
                .debug()
                .do(onNext: { _ in self._page = 1 })
                .flatMapLatest { _ in
                    provider.rx
                        .request(.myRecord(page: self._page, count: 20))
                        .map(NetworkResponse<[Record.Detail]>.self)
                        .map({ (response) -> [Record.Detail] in
                            let array = response.data
                            self._refreshStatus.onNext(.DropDownSuccess)
                            self.dataArray = array
                            self._hasContent.onNext(!array.isEmpty)
                            return self.dataArray
                        })
                        .asDriver(onErrorJustReturn: [])
            }
            
            let loadMore = input.loadMore
                .do(onNext: { _ in self._page += 1 })
                .flatMapLatest { _ in
                    provider.rx.request(.myRecord(page: self._page, count: 20))
                        .map(NetworkResponse<[Record.Detail]>.self)
                        .map({ (response) -> [Record.Detail] in
                            let array = response.data
                            if array.isEmpty {
                                self._refreshStatus.onNext(.PullSuccessNoMoreData)
                            } else {
                                self._refreshStatus.onNext(.PullSuccessHasMoreData)
                            }
                            self.dataArray += array
                            return self.dataArray
                        })
                        .asDriver(onErrorJustReturn: [])
            }
            
            data = Driver.merge(refresh, loadMore)
                .do(onNext: { (models) in
                    if models.isEmpty {
                        self._refreshStatus.onNext(.InvalidData)
                    }
                })
                .map { models in
                    return self.dataArray
            }
        }
    }
}
