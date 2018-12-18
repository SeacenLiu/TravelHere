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
        
        var refreshStatus = BehaviorRelay<RefreshStatus>(value: RefreshStatus.InvalidData)
        var result: Observable<[Record.Detail]>?
        var hasContent = BehaviorRelay<Bool>(value: false)
        private var _page = 1
        private var _loadData = PublishSubject<Int>()
        private var dataArray = [Record.Detail]()
        
        init() {
            let provider = MoyaProvider<Record.NetworkTarget>()
            
            result = _loadData.flatMapLatest { p in
                provider.rx.request(.myRecord(page: p, count: 20))
                    .map(NetworkResponse<[Record.Detail]>.self)
                    .map({ (response) -> [Record.Detail] in
                        let array = response.data
                        if p == 1 {
                            self.refreshStatus.accept(.DropDownSuccess)
                            self.dataArray = array
                        } else {
                            if array.count <= 0 {
                                self.refreshStatus.accept(.PullSuccessNoMoreData)
                            } else {
                                self.refreshStatus.accept(.PullSuccessHasMoreData)
                                self.dataArray += array
                            }
                        }
                        if p == 1 && self.dataArray.count != 0 {
                            self.hasContent.accept(true)
                        }
                        return self.dataArray
                    })
            }
        }
        
        func reloadData() {
            _page = 1
            _loadData.onNext(_page)
        }
        
        func loadMoreData() {
            _page += 1
            _loadData.onNext(_page)
        }
    }
}
