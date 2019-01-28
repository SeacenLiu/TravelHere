//
//  Record.Edit.View.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/27.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

protocol RecordEditViewDelegate: class {
    func recordEditViewDidPublish(v: Record.Edit.View, showNode: THShowNode, isSussess: Bool)
}

extension Record.Edit {
    internal class View: UIViewController {
        private let _disposeBag = DisposeBag()
        fileprivate var _editView: EditView { return view as! EditView }
        override func loadView() { view = EditView.nibView() }
        private lazy var _viewModel = ViewModel(input: (
            text: self._editView.textView.rx.text.orEmpty.asDriver(),
            img: Observable.merge(
                self._editView.imgBtn.rx.tap.asObservable(),
                self._editView.addImgBtn.rx.tap.asObservable())
                .flatMap { [weak self] _ in
                    ImagePickerControl.showActionAndGetImage(from: self)
                }
                .flatMap { [weak self] image in
                    ImageClipControl.cropImage(image!, hwRatio: 195.0/312.0, isCycle: false, from: self)
                }
                .map { img -> UIImage? in img }
                .asDriver(onErrorJustReturn: nil)
                .startWith(nil),
            type: self._editView.templateView.rx.itemSelected
                .map { $0.row }
                .asDriver(onErrorJustReturn: 0)
                .startWith(0),
            location: LocationSearcher(location: PositionManager.shared.currentLocation)
                .rx.search()
                .do(onSuccess: { _ in
                    SVProgressHUD.showSuccess(status: "获取位置成功")
                }, onError: { (err) in
                    SVProgressHUD.showError(status: "获取位置失败")
                    // TODO: - 引导用户连接网络或者打开定位
                }, onSubscribe: {
                    SVProgressHUD.show(withStatus: "正在获取位置信息")
                })
                .asDriver(onErrorJustReturn: .failure),
            doneTap: self._editView.publishBtn.rx.tap.asSignal()))
        /// 代理 有：会自动DisMiss 无：需要手动DisMiss
        public weak var delegate: RecordEditViewDelegate?
    }
}

extension Record.Edit.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        view.rx
            .tapGesture(configuration: { tap, _ in
                tap.cancelsTouchesInView = false
            })
            .map { _ in return () }
            .bind(to: rx.endEditing)
            .disposed(by: _disposeBag)
        _editView.closeBtn.rx.tap.bind(to: rx.dismissAction).disposed(by: _disposeBag)
    }
    
    private func bindingViewModel() {
        _viewModel.typeData
            .drive(_editView.templateView.rx.items(
                cellIdentifier: ShapeTypeCell.reuseIdentifier,
                cellType: ShapeTypeCell.self)) { (row, vm, cell) in
                    cell.config(with: vm)
        }.disposed(by: _disposeBag)
        
        _viewModel.publishEnable
            .drive(_editView.publishBtn.rx.isEnabled)
            .disposed(by: _disposeBag)
        
        _viewModel.publishResult.drive(rx.handlePublish).disposed(by: _disposeBag)
        
        _viewModel.image.drive(rx.image).disposed(by: _disposeBag)
    }
}

// MARK: - Reactive
extension Reactive where Base: Record.Edit.View {
    var handlePublish: AnyObserver<Record.Edit.Result> {
        return Binder<Record.Edit.Result>(base) { c, result in
            if result.success {
                c.showHUD(successText: "发布成功") {
                    if let delegate = c.delegate {
                        let detail = result.model
                        let model = Record.Model.myRecordModel(with: detail)
                        let node = THBaseNode(with: model)
                        c.dismiss(animated: true) {
                            delegate.recordEditViewDidPublish(v: c, showNode: node, isSussess: result.success)
                        }
                    } else {
                        c.dismiss(animated: true)
                    }
                }
            } else {
                c.showHUD(errorText: "发布失败")
            }
        }.asObserver()
    }
    
    var image: AnyObserver<UIImage> {
        return Binder<UIImage>(base) { c, img in
            c._editView.addImgBtn.isHidden = true
            c._editView.imgBtn.isHidden = false
            c._editView.imgBtn.setBackgroundImage(img, for: .normal)
        }.asObserver()
    }
}
