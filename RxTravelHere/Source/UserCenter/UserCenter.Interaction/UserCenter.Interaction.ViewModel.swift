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
        
        var data: Driver<[Model]>!
        var refreshStatus = BehaviorRelay<RefreshStatus>(value: RefreshStatus.InvalidData)
        var hasContent = BehaviorRelay<Bool>(value: false)
        
        private var _page = 1
        private let _count = 20
        private var _loadData = PublishSubject<Int>()
        private var _dataArray = [Model]()
        private let _disposeBag = DisposeBag()
        
        init() {
            let provider = MoyaProvider<NetworkTarget>()
            
            data = _loadData.flatMapLatest { [unowned self] p in
                provider.rx.request(NetworkTarget(page: p, count: self._count))
                    .do(onSuccess: { [unowned self] _ in
                        self.refreshStatus.accept(.InvalidData)
                    })
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
                }.asDriver(onErrorJustReturn: self._dataArray)
            
            // 有新消息之后需要重新加载
            // FIXME: - 其实我需要一个 Model
            // 后台 RabbitMQ 那里返回的东西需要重新商定才可继续优化
            THRedPointManager.shared.newComment
                .asDriver(onErrorJustReturn: .empty)
                .drive(onNext: { [unowned self] _ in
                self.reloadData()
            }).disposed(by: _disposeBag)
        }
        
        func reloadData() {
            _page = 1
            _loadData.onNext(_page)
        }
        
        func loadMoreData() {
            _page += 1
            _loadData.onNext(_page)
        }
        
        public func getRecordShowViewModel(with indexPath: IndexPath) -> Record.Show.ViewModel {
            let model = _dataArray[indexPath.row]
            let recordId = model.messageId
            return Record.Show.ViewModel(with: recordId)
        }
        
        public func readRecord(at indexPath: IndexPath, complete: (()->())? = nil) {
            let cid = _dataArray[indexPath.row].commentId
            THRedPointManager.shared.readComment(cid: cid, completeHandler: complete)
        }
 
        deinit {
            log("UserCenter.Interaction.ViewModel deinit.")
        }
    }
}

