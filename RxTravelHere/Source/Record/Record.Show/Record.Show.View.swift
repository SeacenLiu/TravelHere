//
//  Record.Show.View.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/21.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import MJRefresh

extension Record.Show {
    internal class View: UIViewController {
        private let _disposeBag = DisposeBag()
        
        init(with viewModel: ViewModel) {
            _viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let _dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Any>>(
            configureCell: { (ds, tv, ip, vm) -> UITableViewCell in
                if let vm = vm as? RecordContentRepresentable {
                    let cell = tv.dequeueReusableCell(
                        withIdentifier: RecordContentCell.cellIdentifier,
                        for: ip) as! RecordContentCell
                    cell.config(with: vm)
                    return cell
                } else if let vm = vm as? CommentRepresentable {
                    let cell = tv.dequeueReusableCell(
                        withIdentifier: CommentCell.cellIdentifier,
                        for: ip) as! CommentCell
                    cell.config(with: vm)
                    return cell
                } else {
                    fatalError("加载Cell失败")
                }
        } )
        private let _viewModel: ViewModel
        
        // MARK: - UI Element
        fileprivate lazy var navBarView = NavBarView.naviBarView(with: navigationController)
        fileprivate lazy var tableView = UITableView(style: .grouped) {
            ImageHeadView.registered(by: $0)
            CutView.registered(by: $0)
            RecordContentCell.registered(by: $0)
            CommentCell.registered(by: $0)
        }
        private lazy var drawBtn = UIButton(image: #imageLiteral(resourceName: "edit_comment_btn"))
        private lazy var inputer = THInputView() { [weak self] (text: String)->Void in
            guard let `self` = self else { return }
            self._viewModel.sendComment(with: text)
            self.inputer.dismiss()
        }
        
        // MARK: - compute relate
        private var headerH: CGFloat {
            return ImageHeadView.headerHeight(with: self.tableView)
        }
        private var contentH: CGFloat = 0
        private let cutH = CutView.headerHeight
        private var showBottomY: CGFloat = 0
    }
}

extension Record.Show.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            [unowned self] in
            self._viewModel.loadMoreComment()
        })
        
        // ---
        tableView.rx.didScroll
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: rx.scrollAction)
            .disposed(by: _disposeBag)
        
        tableView.rx.willDisplayCell.subscribe(onNext: { [unowned self] cell ,ip in
            if ip.section == 0 {
                self.contentH = cell.bounds.height
            }
        }).disposed(by: _disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] ip in
            self.tableView.deselectRow(at: ip, animated: true)
        }).disposed(by: _disposeBag)
        
        drawBtn.rx.tap.subscribe(onNext: { [unowned self] btn in
            self.showInputer()
        }).disposed(by: _disposeBag)
    }
    
    private func binding() {
        tableView.rx.setDelegate(self).disposed(by: _disposeBag)
        _viewModel.data
            .drive(tableView.rx.items(dataSource: _dataSource))
            .disposed(by: _disposeBag)
        _viewModel.refreshStatus
            .drive(tableView.rx.mj_refreshStatus)
            .disposed(by: _disposeBag)
        _viewModel.headImage
            .drive(rx.headerImage)
            .disposed(by: _disposeBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(drawBtn)
        view.addSubview(navBarView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        drawBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        navBarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(UIDevice.statusBarH + 44)
        }
        
        navBarView.barAlpha = 0
    }
}

// MARK: - input view relate
private extension Record.Show.View {
    func showInputer(indexPath: IndexPath = IndexPath(row: 0, section: 0)) {
        showBottomY = contentH + headerH + cutH
        inputer.show(with: "评论:")
    }
}

extension Record.Show.View: UITableViewDelegate {
    // TODO: - 美化代理
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return ImageHeadView.load(with: tableView)
        } else {
            return CutView.load(with: tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return ImageHeadView.headerHeight(with: tableView)
        } else {
            return CutView.headerHeight
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}

extension Reactive where Base: Record.Show.View {
    var headerImage: AnyObserver<UIImage> {
        return Binder<UIImage>(base) { v, img in
            if let head = v.tableView.headerView(forSection: 0) as? ImageHeadView {
                head.imageView.image = img
            }
        }.asObserver()
    }
    
    var scrollAction: AnyObserver<Void> {
        return Binder<Void>(base) { v, _ in
            let tv = v.tableView
            v.navBarView.change(with: tv, headerH: ImageHeadView.headerHeight(with: tv))
            if let head = tv.headerView(forSection: 0) as? ImageHeadView {
                head.change(with: tv)
            }
        }.asObserver()
    }
}
