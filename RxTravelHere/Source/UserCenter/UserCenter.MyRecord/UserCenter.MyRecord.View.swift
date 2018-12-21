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
        
        private lazy var _viewModel = ViewModel(
            input: (
                refresh: MJRefreshStateHeader
                    .create(from: self.tableView)
                    .asDriver(onErrorJustReturn: ()),
                loadMore: MJRefreshBackNormalFooter
                    .create(from: self.tableView)
                    .asDriver(onErrorJustReturn: ())
            ), service: LoadDataService()
        )
        
        private lazy var emptyView = EmptyView(text: "留言是空的，快去留言吧~")
        private lazy var tableView: UITableView = {
            let tv = UITableView()
            tv.register(UINib.init(nibName: "RecordCell", bundle: nil), forCellReuseIdentifier: RecordCell.cellIdentifier)
            return tv
        }()
        
        deinit {
            log("UserCenter.MyRecord View")
        }
    }
}

extension UserCenter.MyRecord.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        _viewModel.hasContent
            .drive(emptyView.rx.isHidden)
            .disposed(by: _disposeBag)
        
        _viewModel.data
            .drive(tableView.rx.items(
                cellIdentifier: RecordCell.cellIdentifier,
                cellType: RecordCell.self)) {
                    (row, vm, cell) in
                    cell.config(with: vm)
            }.disposed(by: _disposeBag)
        
        _viewModel.refreshStatus
            .drive(tableView.rx.mj_refreshStatus)
            .disposed(by: _disposeBag)
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
