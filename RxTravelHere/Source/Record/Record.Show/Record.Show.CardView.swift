//
//  Record.Show.CardView.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2019/1/6.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxGesture
import MJRefresh

extension Record.Show {
    internal class CardView: UIView {
        private let _disposeBag = DisposeBag()
        private var _bindingBag: DisposeBag?
        
        func config(with vm: ViewModel) {
            // Binding !!!
            _bindingBag = DisposeBag()
            guard let disposeBag = _bindingBag else { fatalError("_bindingBag 错误.") }
            // binding input
            MJRefreshBackNormalFooter.create(from: tableView)
                .bind(to: vm.loadMoreComment)
                .disposed(by: disposeBag)
            inputer.rx.clickEnter
                .do(onNext: { [unowned self] _ in self.inputer.dismiss() })
                .bind(to: vm.sendComment)
                .disposed(by: disposeBag)
            // binding output
            tableView.rx.setDelegate(self).disposed(by: disposeBag)
            vm.data
                .drive(tableView.rx.items(dataSource: _dataSource))
                .disposed(by: disposeBag)
            vm.refreshStatus
                .drive(tableView.rx.mj_refreshStatus)
                .disposed(by: disposeBag)
            vm.headImage
                .drive(headImageView.rx.image)
                .disposed(by: disposeBag)
        }
        
        init() {
            super.init(frame: .zero)
            setupUI()
            setUpInteraction()
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
        
        // MARK: - UI Element
        lazy var headImageView = UIImageView(image: UIImage(named: "test_head_img"))
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

extension Record.Show.CardView {
    public func showView(frame: CGRect, finish: (()->())? = nil) {
        if let v = UIViewController.currentController?.view {
            v.addSubview(self)
            self.frame = frame
            layer.cornerRadius = 10
            layer.masksToBounds = true
            transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 6, options: .curveLinear, animations: {
                self.transform = CGAffineTransform.identity
                finish?()
            })
        }
    }
    
    public func closeView(finish: (()->())? = nil) {
        inputer.dismiss()
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (_) in
            self.removeFromSuperview()
            self.transform = .identity
            finish?()
        }
    }
}

extension Record.Show.CardView {
    private func setUpInteraction() {
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
        
        drawBtn.rx.tap.bind(to: rx.showInputer).disposed(by: _disposeBag)
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(tableView)
        addSubview(drawBtn)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        drawBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}

// MARK: - UITableViewDelegate
extension Record.Show.CardView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = ImageHeadView.load(with: tableView)
            // FIXME: - 无法修改图片
            header.imageView = headImageView
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
extension Reactive where Base: Record.Show.CardView {
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
            let inputerT = rect.minY - (UIScreen.main.bounds.height - v.frame.maxY)
            let cellB = v.showBottomY
            var offset = cellB - inputerT
            if offset < 0 { offset = 0 }
            v.tableView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
            }.asObserver()
    }
    
    var scrollAction: AnyObserver<Void> {
        return Binder<Void>(base) { v, _ in
            let tv = v.tableView
            if let head = tv.headerView(forSection: 0) as? ImageHeadView {
                head.change(with: tv)
            }
            }.asObserver()
    }
}

