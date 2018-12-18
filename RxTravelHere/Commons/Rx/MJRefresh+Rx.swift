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
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshing()
            return
        case .DropDownSuccess:
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.resetNoMoreData()
        case .PullSuccessHasMoreData:
            tableView.mj_footer.endRefreshing()
        case .PullSuccessNoMoreData:
            tableView.mj_footer.endRefreshingWithNoMoreData()
        }
        tableView.mj_header.endRefreshing()
    }
}
