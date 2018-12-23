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

protocol TableViewLoadDataService {
    associatedtype Element: Decodable
    associatedtype TargetType: NetworkTarget
    
    var provider: MoyaProvider<TargetType> { get }
    func loadData(with page: Int, count: Int) -> Driver<NetworkValid<[Element]>>
}

extension UserCenter.MyRecord {
    internal class ViewModel {
        
        typealias ModelType = Record.Detail
        
        var data: Driver<[ModelType]>!
        var refreshStatus: Driver<RefreshStatus> {
            return _refreshStatus.asDriver(onErrorJustReturn: .InvalidData)
        }
        var hasContent: Driver<Bool> {
            return _hasContent.asDriver(onErrorJustReturn: false)
        }
        
        var _refreshStatus = PublishSubject<RefreshStatus>()
        var _hasContent = PublishSubject<Bool>()
        
        private var _page = 1
        private let _count = 20
        private var _dataArray = [ModelType]()
        
        init(input: (refresh: Driver<()>, loadMore: Driver<()>), service: LoadDataService) {
            let loadMyRecordService = service
            
            let refresh = Driver.merge(input.refresh, Driver.of(()))
                .do(onNext: { [unowned self] _ in self._page = 1 })
                .flatMapLatest { [unowned self] _  in
                    loadMyRecordService
                        .loadData(with: self._page, count: self._count)
                        .map { [unowned self] (valid) -> [ModelType] in
                            switch valid {
                            case let .success(value: v):
                                self._refreshStatus.onNext(.DropDownSuccess)
                                self._hasContent.onNext(!v.isEmpty)
                                self._dataArray = v
                            case .failure:
                                self._refreshStatus.onNext(.InvalidData)
                            }
                            return self._dataArray
                        }
            }
            
            let loadMore = input.loadMore
                .do(onNext: { [unowned self] _ in self._page += 1 })
                .flatMapLatest { [unowned self] _ in
                    loadMyRecordService
                        .loadData(with: self._page, count: self._count)
                        .map { [unowned self] (valid) -> [ModelType] in
                            switch valid {
                            case let .success(value: v):
                                if v.isEmpty {
                                    self._refreshStatus.onNext(.PullSuccessNoMoreData)
                                } else {
                                    self._refreshStatus.onNext(.PullSuccessHasMoreData)
                                }
                                self._dataArray += v
                            case .failure:
                                self._refreshStatus.onNext(.InvalidData)
                            }
                            return self._dataArray
                        }
            }
            
            data = Driver.merge(refresh, loadMore)
        }
        
        public func getRecordShowViewModel(with indexPath: IndexPath) -> Record.Show.ViewModel {
            let recordDetail = _dataArray[indexPath.row]
            let recordModel = Record.Model.myRecordModel(with: recordDetail)
            return Record.Show.ViewModel(with: recordModel)
        }
        
        deinit {
            log("UserCenter.MyRecord.ViewModel deinit.")
        }
    }
    
    internal class LoadDataService: TableViewLoadDataService {
        typealias Element = Record.Detail
        
        let provider = MoyaProvider<Record.NetworkTarget>()
        
        func loadData(with page: Int, count: Int) -> Driver<NetworkValid<[Element]>> {
            return provider.rx
                .request(.myRecord(page: page, count: 20))
                .map(NetworkResponse<[Element]>.self)
                .map { .success(value: $0.data) }
                .asDriver(onErrorJustReturn: .failure)
        }
    }
}
