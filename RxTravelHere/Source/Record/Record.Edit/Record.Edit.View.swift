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

extension Record.Edit {
    internal class View: UIViewController {
        private let _disposeBag = DisposeBag()
        private var _editView: EditView { return view as! EditView }
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
                    ImageClipControl.cropImage(image!, isCycle: true, from: self)
                }
                .map { img -> UIImage? in img }
                .asDriver(onErrorJustReturn: nil)
                .startWith(nil),
            type: self._editView.templateView.rx.itemSelected
                .map { $0.row }
                .asDriver(onErrorJustReturn: 0)
                .startWith(0),
            doneTap: self._editView.publishBtn.rx.tap.asSignal()))
        
    }
}

extension Record.Edit.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        _editView.closeBtn.rx.tap.bind(to: rx.dismissAction).disposed(by: _disposeBag)
        
    }
    
    private func bindingViewModel() {
        _viewModel.typeData
            .drive(_editView.templateView.rx.items(
                cellIdentifier: ShapeTypeCell.reuseIdentifier,
                cellType: ShapeTypeCell.self)) { (row, vm, cell) in
                    cell.config(with: vm)
        }.disposed(by: _disposeBag)
    }
}
