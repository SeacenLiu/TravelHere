//
//  View.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Account.Edit {
    final class View: UIViewController {
        private var _editView: EditInfoView { return view as! EditInfoView }
        
        let _disposeBag = DisposeBag()
        
        override func loadView() {
            view = EditInfoView.nibView()
        }
        
        private lazy var _viewModel = ViewModel(
            input: (
                avatar: self._editView.editAvatarBtn.rx.tap
                    .flatMap { [weak self] _ in
                        ImagePickerControl.showActionAndGetImage(from: self)
                    }
                    .filter {image in image != nil}
                    .flatMap { [weak self] image in
                        ImageClipControl.cropImage(image!, isCycle: true, from: self)
                    }
                    .asDriver(onErrorJustReturn: UIImage()),
                name: self._editView.nameTf.rx.text.orEmpty.asDriver(),
                doneTaps: self._editView.doneBtn.rx.tap.asSignal()
            )
        )
    }
}

extension Account.Edit.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _viewModel.avatar
            .drive(_editView.avatarBtn.rx.backgroundImage(for: .normal))
            .disposed(by: _disposeBag)
        
        _viewModel.name
            .drive(_editView.nameTf.rx.text)
            .disposed(by: _disposeBag)
        
        _viewModel.validateName
            .drive(_editView.doneBtn.rx.isEnabled)
            .disposed(by: _disposeBag)
        
        _viewModel.done
            .drive(rx.doneHandler)
            .disposed(by: _disposeBag)

    }
}

extension Reactive where Base: Account.Edit.View {
    var doneHandler: AnyObserver<Bool> {
        return Binder<Bool>(base) { c, v in
            if v {
                c.showHUD(successText: "修改成功")
                c.dismiss(animated: true)
            } else {
                c.showHUD(errorText: "修改失败")
            }
        }.asObserver()
    }
}

final class EditInfoView: UIView {
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var editAvatarBtn: UIButton!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doneBtn.setColorInState(normal: #colorLiteral(red: 0, green: 0.7176470588, blue: 0.8039215686, alpha: 1), highlighted: nil, selected: nil, disabled: #colorLiteral(red: 0.5607843137, green: 0.5607843137, blue: 0.5607843137, alpha: 1))
    }
}
