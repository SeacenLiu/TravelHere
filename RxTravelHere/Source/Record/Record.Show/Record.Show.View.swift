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
import RxGesture
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
        fileprivate lazy var inputer = THInputView()
        
        // MARK: - compute relate
        private var headerH: CGFloat {
            return ImageHeadView.headerHeight(with: self.tableView)
        }
        fileprivate var contentH: CGFloat = 0
        private let cutH = CutView.headerHeight
        fileprivate var showBottomY: CGFloat {
            return contentH + headerH + cutH
        }
    }
}

extension Record.Show.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindingViewModel()
        
        tableView.rx.didScroll
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: rx.scrollAction)
            .disposed(by: _disposeBag)
        
        tableView.rx.panGesture()
            .map { _ in return () }
            .bind(to: inputer.rx.dismiss)
            .disposed(by: _disposeBag)
        
        tableView.rx
            .tapGesture(configuration: { tap, _ in
                tap.cancelsTouchesInView = false
            })
            .map { _ in return () }
            .bind(to: inputer.rx.dismiss)
            .disposed(by: _disposeBag)
        
        inputer.rx.frameChange
            .bind(to: rx.tableViewContentOffset)
            .disposed(by: _disposeBag)
        
        tableView.rx.willDisplayCell
            .bind(to: rx.contentHeight)
            .disposed(by: _disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] ip in
            self.tableView.deselectRow(at: ip, animated: true)
            guard let vm = self._viewModel.getReplyViewModel(indexPath: ip) else {
                return
            }
            ActionSheetControl.show(from: self, menu: ["回复"])
                .subscribe(onNext: { _ in
                    let v = Record.Reply.View(with: vm)
                    self.navigationController?.pushViewController(v, animated: true)
                }).disposed(by: self._disposeBag)
        }).disposed(by: _disposeBag)
        
        drawBtn.rx.tap.bind(to: rx.showInputer).disposed(by: _disposeBag)
    }
    
    private func bindingViewModel() {
        // binding input
        MJRefreshBackNormalFooter.create(from: tableView)
            .bind(to: _viewModel.loadMoreComment)
            .disposed(by: _disposeBag)
        inputer.rx.clickEnter
            .do(onNext: { [unowned self] _ in self.inputer.dismiss() })
            .bind(to: _viewModel.sendComment)
            .disposed(by: _disposeBag)
        // binding output
        tableView.rx.setDelegate(self).disposed(by: _disposeBag)
        _viewModel.data
            .drive(tableView.rx.items(dataSource: _dataSource))
            .disposed(by: _disposeBag)
        _viewModel.refreshStatus
            .drive(tableView.rx.mj_refreshStatus)
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

// MARK: - UITableViewDelegate
extension Record.Show.View: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = ImageHeadView.load(with: tableView)
            // FIXME: - 绑定位置奇特
            _viewModel.headImage
                .drive(header.imageView.rx.image)
                .disposed(by: _disposeBag)
            return header
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

// MARK: - Reactive
extension Reactive where Base: Record.Show.View {
    var showInputer: AnyObserver<Void> {
        return Binder<Void>(base) { v, _ in
            v.inputer.show(with: "评论:")
        }.asObserver()
    }
    
    // table view part
    var headerImage: AnyObserver<UIImage> {
        return Binder<UIImage>(base) { v, img in
            if let head = v.tableView.headerView(forSection: 0) as? ImageHeadView {
                head.imageView.image = img
            }
            }.asObserver()
    }
    
    var contentHeight: AnyObserver<WillDisplayCellEvent> {
        return Binder<WillDisplayCellEvent>(base) { v, tuple in
            if tuple.1.section == 0 {
                v.contentH = tuple.0.bounds.height
            }
            }.asObserver()
    }
    
    var tableViewContentOffset: AnyObserver<CGRect> {
        return Binder<CGRect>(base) { v, rect in
            let inputerT = rect.minY - (UIScreen.main.bounds.height - v.view.frame.maxY)
            let cellB = v.showBottomY
            var offset = cellB - inputerT
            if offset < 0 { offset = 0 }
            v.tableView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
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
