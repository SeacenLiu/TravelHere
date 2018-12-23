//
//  Record.Show.ViewModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/21.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Moya

extension Record.Show {
    /// 两种初始方式
    // * 通过整个 Record.Model 初始化
    // * 通过一个 Record.Detail.id 初始化
    internal class ViewModel {
        var data: Driver<[SectionModel<String, Any>]>!
        var refreshStatus: Driver<RefreshStatus> {
            return _refreshStatus.asDriver(onErrorJustReturn: .InvalidData)
        }
        
        private let _commentLoadData = BehaviorRelay<Int>(value: 1)
        private let _refreshStatus = BehaviorRelay<RefreshStatus>(value: RefreshStatus.InvalidData)
        private let _disposeBag = DisposeBag()

        private var _record: Record.Model?
        private var _commentPage = 1
        private let _count = 20
        
        private var _comments = [Comment.Model]()
        
        init(with record: Record.Model) {
            _record = record
            
            let provider = MoyaProvider<Comment.NetworkTarget>()
            data = _commentLoadData
                .debug()
                .flatMap { [unowned self] p in
                    provider.rx
                        .request(.commentByRecord(messageId: record.detail.id, page: p, count: self._count))
                        .map(NetworkResponse<[Comment.Model]>.self)
                        .do(onError: { [unowned self] err in
                            log(err)
                            self._refreshStatus.accept(.InvalidData)
                        })
                        .map { commemts -> [SectionModel<String, Any>] in
                            let new = commemts.data
                            if new.isEmpty {
                                self._refreshStatus.accept(.PullSuccessNoMoreData)
                            } else {
                                self._refreshStatus.accept(.PullSuccessHasMoreData)
                                self._comments += new
                            }
                            return [SectionModel<String, Any>(model: "R", items: [record]),
                             SectionModel<String, Any>(model: "C", items: self._comments)] }
            }.asDriver(onErrorJustReturn: [SectionModel<String, Any>(model: "R", items: [record])])
        }
        
        func loadMoreComment() {
            // TODO: - 加载更多评论
            _commentPage += 1
            _commentLoadData.accept(_commentPage)
        }
    }
}
