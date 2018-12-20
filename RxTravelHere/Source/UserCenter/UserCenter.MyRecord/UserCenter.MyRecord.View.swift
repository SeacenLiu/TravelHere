//
//  UserCenter.MyRecord.View.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/17.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import MJRefresh

extension UserCenter.MyRecord {
    internal class View: UIViewController {
        private lazy var _disposeBag = DisposeBag()
        private lazy var _viewModel = ViewModel()
        private lazy var emptyView = EmptyView(text: "留言是空的，快去留言吧~")
        private lazy var tableView: UITableView = {
            let tv = UITableView()
            tv.register(UINib.init(nibName: "RecordCell", bundle: nil), forCellReuseIdentifier: RecordCell.cellIdentifier)
            tv.contentInset = UIEdgeInsets(top: -54, left: 0, bottom: 0, right: 0)
            return tv
        }()
    }
}

extension UserCenter.MyRecord.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.mj_header = MJRefreshStateHeader(refreshingBlock: {
            self._viewModel.reloadData()
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self._viewModel.loadMoreData()
        })
        
        _viewModel.result?
            .bind(to: tableView.rx.items(
                cellIdentifier: RecordCell.cellIdentifier,
                cellType: RecordCell.self)) {
                    (row, element, cell) in
                    cell.model = element
            }.disposed(by: _disposeBag)
        
        _viewModel.refreshStatus
            .bind(to: tableView.rx.mj_refreshStatus)
            .disposed(by: _disposeBag)
        
        _viewModel.hasContent
            .bind(to: emptyView.rx.isHidden)
            .disposed(by: _disposeBag)
        
        // 加载第一页
        tableView.mj_header.beginRefreshing()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(emptyView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        emptyView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
}