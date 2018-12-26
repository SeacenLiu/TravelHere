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
import Kingfisher
import Moya

extension Record.Show {
    
    internal class ViewModel {
        var data: Driver<[SectionModel<String, Any>]>!
        var headImage: Driver<UIImage>!
        var refreshStatus: Driver<RefreshStatus> {
            return _refreshStatus.asDriver(onErrorJustReturn: .InvalidData)
        }
        
        private let _commentLoadData = BehaviorRelay<Int>(value: 1)
        private let _refreshStatus = BehaviorRelay<RefreshStatus>(value: RefreshStatus.InvalidData)
        private let _recordSubjuect = BehaviorRelay<Record.Model>(value: Record.Model.emptyModel)
        private let _disposeBag = DisposeBag()
        private var _comments = [Comment.Model]()
        private var _commentPage = 1
        private let _count = 20
        
        private let commentProvider = MoyaProvider<Comment.NetworkTarget>()
        
        init(with recordId: Int) {
            loadData()
            
            let recordProvider = MoyaProvider<Record.NetworkTarget>()
            recordProvider.rx
                .request(.oneRecord(id: recordId))
                .map(NetworkResponse<Record.Model>.self)
                .map{ $0.data }
                .asObservable()
                .bind(to: _recordSubjuect)
                .disposed(by: _disposeBag)
        }
        
        init(with record: Record.Model) {
            loadData()
            _recordSubjuect.accept(record)
        }
        
        public func loadMoreComment() {
            _commentPage += 1
            _commentLoadData.accept(_commentPage)
        }
        
        // FIXME: - 有问题的
        public func sendComment(with text: String) {
            // 1. HUD show
            // 2. Network
            // 3. HUD dismiss
            // 4. add cell
            commentProvider.rx
                .request(.sendComment(
                    messageId: _recordSubjuect.value.id,
                    commentContent: text))
                .map(NetworkResponse<Comment.Model>.self)
                .subscribe(onSuccess: { [unowned self] (response) in
                    let new = response.data
                    self._comments.insert(new, at: 0)
                    
                }) { (err) in
                    log(err)
            }.disposed(by: _disposeBag)
        }
        
        private func loadData() {
            let recordLoadDriver = _recordSubjuect
                .map { [SectionModel<String, Any>(model: "R", items: [$0]),
                        SectionModel<String, Any>(model: "C", items: self._comments)] }
                .asDriver(onErrorJustReturn: [SectionModel<String, Any>(model: "R", items: [Record.Model.emptyModel]),
                                              SectionModel<String, Any>(model: "C", items: self._comments)])
            
            let commentLoadDriver = Observable
                .combineLatest(_recordSubjuect, _commentLoadData)
                .filter { !$0.0.isEmpty }
                .flatMapLatest { [unowned self] tuples in
                    self.commentProvider.rx
                        .request(.commentByRecord(messageId: tuples.0.detail.id, page: tuples.1, count: self._count))
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
                            return [SectionModel<String, Any>(model: "R", items: [tuples.0]),
                                    SectionModel<String, Any>(model: "C", items: self._comments)] }
                }.asDriver(onErrorJustReturn: [SectionModel<String, Any>(model: "R", items: [_recordSubjuect.value])])
            
            data = Driver.merge(recordLoadDriver, commentLoadDriver)
            
            headImage = _recordSubjuect
                .map { $0.imageResource }
                .filter { $0 != nil }
                .flatMapLatest {KingfisherManager.shared.rx.loadImage(with: $0!)}
                .asDriver(onErrorJustReturn: UIImage(named: "test_head_img")!)
        }
    }
}
