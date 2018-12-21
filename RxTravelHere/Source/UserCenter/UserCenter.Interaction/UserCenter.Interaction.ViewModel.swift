//
//  UserCenter.Interaction.ViewModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/21.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

extension UserCenter.Interaction {
    internal class ViewModel {
        
        var data: Observable<[Model]>!
        var refreshStatus = BehaviorRelay<RefreshStatus>(value: RefreshStatus.InvalidData)
        var hasContent = BehaviorRelay<Bool>(value: false)
        
        private var _page = 1
        private let _count = 20
        private var _loadData = PublishSubject<Int>()
        private var _dataArray = [Model]()
        
        init() {
            let provider = MoyaProvider<NetworkTarget>()
            
            data = _loadData.flatMapLatest { [unowned self] p in
                provider.rx.request(NetworkTarget(page: p, count: self._count))
                    .map(NetworkResponse<[Model]>.self)
                    .map({ [unowned self] (response) -> [Model] in
                        let array = response.data
                        if p == 1 {
                            self.refreshStatus.accept(.DropDownSuccess)
                            self._dataArray = array
                        } else {
                            if array.count <= 0 {
                                self.refreshStatus.accept(.PullSuccessNoMoreData)
                            } else {
                                self.refreshStatus.accept(.PullSuccessHasMoreData)
                                self._dataArray += array
                            }
                        }
                        if p == 1 && self._dataArray.count != 0 {
                            self.hasContent.accept(true)
                        }
                        return self._dataArray
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
        
        deinit {
            log("UserCenter.Interaction.ViewModel deinit.")
        }
    }
}

