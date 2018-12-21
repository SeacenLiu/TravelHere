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
                .do(onNext: { [unowned self] _ in self._page = 1 })
                .flatMapLatest { [unowned self] _  in
                    provider.rx
                        .request(.myRecord(page: self._page, count: 20))
                        .map(NetworkResponse<[Record.Detail]>.self)
                        .map({ (response) -> NetworkValid<[Record.Detail]> in
                            let array = response.data
                            self._refreshStatus.onNext(.DropDownSuccess)
                            self.dataArray = array
                            self._hasContent.onNext(!array.isEmpty)
                            return .success(value: self.dataArray)
                        })
                        .asDriver(onErrorJustReturn: .failure)
            }
            
            let loadMore = input.loadMore
                .do(onNext: { [unowned self] _ in self._page += 1 })
                .flatMapLatest { [unowned self] _ in
                    provider.rx.request(.myRecord(page: self._page, count: 20))
                        .map(NetworkResponse<[Record.Detail]>.self)
                        .map({ (response) -> NetworkValid<[Record.Detail]> in
                            let array = response.data
                            if array.isEmpty {
                                self._refreshStatus.onNext(.PullSuccessNoMoreData)
                            } else {
                                self._refreshStatus.onNext(.PullSuccessHasMoreData)
                            }
                            self.dataArray += array
                            return .success(value: self.dataArray)
                        })
                        .asDriver(onErrorJustReturn: .failure)
            }
            
            data = Driver.merge(refresh, loadMore)
                .map { [unowned self] valid in
                    switch valid {
                    case let .success(value: array):
                        return array
                    case .failure:
                        self._refreshStatus.onNext(.InvalidData)
                        return self.dataArray
                    }
            }
        }
        
        deinit {
            log("UserCenter.MyRecord.ViewModel deinit.")
        }
    }
}
