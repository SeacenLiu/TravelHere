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
import SVProgressHUD

extension Record.Show {
    internal class ViewModel {
        
        // MARK: - Output
        var headImage: Driver<UIImage>!
        var data: Driver<[SectionModel<String, Any>]>!
        var refreshStatus: Driver<RefreshStatus> {
            return _refreshStatus.asDriver(onErrorJustReturn: .InvalidData)
        }
        
        // MARK: - Input
        var loadMoreComment: AnyObserver<Void> {
            return _loadMoreComment.asObserver()
        }
        var sendComment: AnyObserver<String> {
            return _sendComment.asObserver()
        }
        
        private let _loadMoreComment = PublishSubject<Void>()
        private let _recordSubject = BehaviorRelay<Record.Model>(value: .empty)
        private let _commentsSubject = BehaviorRelay<[Comment.Model]>(value: [])
        private let _refreshStatus = BehaviorRelay<RefreshStatus>(value: RefreshStatus.InvalidData)
        private let _sendComment = PublishSubject<String>()
        private let _disposeBag = DisposeBag()
        
        private var _commentPage = 0
        private let _count = 20
        private let commentProvider = MoyaProvider<Comment.NetworkTarget>()
        
        convenience init(with recordId: Int) {
            self.init()
            let recordProvider = MoyaProvider<Record.NetworkTarget>()
            recordProvider.rx
                .request(.oneRecord(id: recordId))
                .map(NetworkResponse<Record.Model>.self)
                .map{ $0.data }
                .asObservable()
                .bind(to: _recordSubject)
                .disposed(by: _disposeBag)
        }
        
        convenience init(with record: Record.Model) {
            self.init()
            _recordSubject.accept(record)
        }
        
        init() {
            let loadDataByRecord = _recordSubject
                .do(onNext: { [unowned self] _ in
                    self._commentPage = 0
                    self._loadMoreComment.onNext(())
                })
                .map { [SectionModel<String, Any>(model: "R", items: [$0]),
                        SectionModel<String, Any>(model: "C", items: self._commentsSubject.value)] }
                .asDriver(onErrorJustReturn: [SectionModel<String, Any>(model: "R", items: [Record.Model.empty]),
                                              SectionModel<String, Any>(model: "C", items: self._commentsSubject.value)])
            
            let loadDataByComments = _commentsSubject
                .map { [SectionModel<String, Any>(model: "R", items: [self._recordSubject.value]),
                        SectionModel<String, Any>(model: "C", items: $0)] }
                .asDriver(onErrorJustReturn: [SectionModel<String, Any>(model: "R", items: [self._recordSubject.value]),
                                              SectionModel<String, Any>(model: "C", items: [])])
            
            data = Driver.of(loadDataByRecord, loadDataByComments).merge()
            
            headImage = _recordSubject
                .map { $0.imageResource }
                .filter { $0 != nil }
                .flatMapLatest {KingfisherManager.shared.rx.loadImage(with: $0!)}
                .asDriver(onErrorJustReturn: UIImage(named: "test_head_img")!)
            
            _loadMoreComment.asDriver(onErrorJustReturn: ())
                .filter { [unowned self] _ in !self._recordSubject.value.isEmpty }
                .do(onNext: { [unowned self] _ in self._commentPage += 1 })
                .flatMap { [unowned self] _ in
                    self.commentProvider.rx
                        .request(.commentByRecord(
                            messageId: self._recordSubject.value.id,
                            page: self._commentPage,
                            count: self._count))
                        .map(NetworkResponse<[Comment.Model]>.self)
                        .do(onError: { [unowned self] _ in
                            self._refreshStatus.accept(.InvalidData)
                        })
                        .map { $0.data }
                        .asDriver(onErrorJustReturn: [])
                }
                .do(onNext: { [unowned self] new in
                    if new.isEmpty {
                        self._refreshStatus.accept(.PullSuccessNoMoreData)
                    } else {
                        self._refreshStatus.accept(.PullSuccessHasMoreData)
                    }
                })
                .map { [unowned self] news in self._commentsSubject.value + news }
                .drive(_commentsSubject)
                .disposed(by: _disposeBag)
            
            _sendComment
                .asDriver(onErrorJustReturn: "")
                .filter { (text) -> Bool in
                    if text.isEmpty {
                        SVProgressHUD.showTip(status: "请输入评论内容")
                        return false
                    } else {
                        return true
                    }
                }
                .flatMapLatest { [unowned self] reply in
                    self.commentProvider.rx
                        .request(.sendComment(
                            messageId: self._recordSubject.value.id,
                            commentContent: reply))
                        .map(NetworkResponse<Comment.Model>.self)
                        .map { $0.data }
                    .asDriver(onErrorJustReturn: Comment.Model.empty)
                }
                .filter({ (comment) -> Bool in
                    if comment.isEmpty {
                        SVProgressHUD.showError(status: "评论失败")
                    } else {
                        SVProgressHUD.showSuccess(status: "评论成功")
                    }
                    return !comment.isEmpty
                })
                .map { [unowned self] new in [new] + self._commentsSubject.value }
                .drive(_commentsSubject)
                .disposed(by: _disposeBag)
        }
        
        public func getReplyViewModel(indexPath: IndexPath) -> Record.Reply.ViewModel? {
            if _recordSubject.value.user != Account.Manager.shared.user { return nil }
            let comment = _commentsSubject.value[indexPath.row]
            if comment.reply != nil { return nil }
            return Record.Reply.ViewModel(with: comment) { [unowned self] replyText -> Void in
                var comments = self._commentsSubject.value
                var comment = comments[indexPath.row]
                comment.reply(text: replyText)
                comments[indexPath.row] = comment
                self._commentsSubject.accept(comments)
            }
        }
    }
}
