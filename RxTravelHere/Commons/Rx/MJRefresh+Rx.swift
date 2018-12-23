//
//  MJRefresh+Rx.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/18.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import MJRefresh
import RxSwift
import RxCocoa

enum RefreshStatus {
    case InvalidData
    case DropDownSuccess
    case PullSuccessHasMoreData
    case PullSuccessNoMoreData
}

extension Reactive where Base: UITableView {
    var mj_refreshStatus: AnyObserver<RefreshStatus> {
        return Binder<RefreshStatus>(base) { tv, status in
            self.refreshStatus(status: status, tableView: tv)
        }.asObserver()
    }
    
    /// 设置刷新状态
    func refreshStatus(status:RefreshStatus,tableView: UITableView) {
        switch status {
        case .InvalidData:
            tableView.mj_header?.endRefreshing()
            tableView.mj_footer?.endRefreshingWithNoMoreData()
        case .DropDownSuccess:
            tableView.mj_header?.endRefreshing()
            tableView.mj_footer?.resetNoMoreData()
        case .PullSuccessHasMoreData:
            tableView.mj_footer?.endRefreshing()
        case .PullSuccessNoMoreData:
            tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
        tableView.mj_header?.endRefreshing()
    }
}

protocol MJRefreshHeaderCreater { }
extension MJRefreshHeaderCreater where Self: MJRefreshHeader {
    static func create(from: UIScrollView, config: ((Self) -> ())? = nil) -> Observable<()> {
        return Observable.create { [unowned from] subscribe in
            let header = Self.init(refreshingBlock: {
                subscribe.onNext(())
            })
            config?(header!)
            from.mj_header = header
            return Disposables.create()
        }
    }
}
extension MJRefreshHeader: MJRefreshHeaderCreater { }

protocol MJRefreshFooterCreater { }
extension MJRefreshFooterCreater where Self: MJRefreshFooter {
    static func create(from: UIScrollView, config: ((Self) -> ())? = nil) -> Observable<()> {
        return Observable.create { [unowned from] subscribe in
            let footer = Self.init(refreshingBlock: {
                subscribe.onNext(())
            })
            config?(footer!)
            from.mj_footer = footer
            return Disposables.create()
        }
    }
}
extension MJRefreshFooter: MJRefreshFooterCreater { }
