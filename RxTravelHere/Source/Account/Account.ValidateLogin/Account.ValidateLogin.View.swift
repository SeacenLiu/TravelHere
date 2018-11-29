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

extension Account.ValidateLogin {
    final class View: UIViewController {
        private var _codeView: CodeView { return view as! CodeView }
        
        let _disposeBag = DisposeBag()
        
        override func loadView() {
            view = CodeView.nibView()
        }
        
        private lazy var _viewModel = ViewModel(
            input: (
                code: self._codeView.codeTf.rx.text.orEmpty.asDriver(),
                loginTaps: self._codeView.loginBtn.rx.tap.asSignal()
            )
        )
    }
}

extension Account.ValidateLogin.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _viewModel.validatedCode
            .drive(_codeView.loginBtn.rx.isEnabled)
            .disposed(by: _disposeBag)
        
        _viewModel.login.drive(onNext: {
            if ($0) {
                self.navigationController?.pushViewController(
                    Account.Edit.View(),
                    animated: true)
            } else {
                log("send fail.")
            }
        }).disposed(by: _disposeBag)
    }
}

final class CodeView: UIView {
    @IBOutlet weak var codeTf: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loginBtn.setColorInState(normal: #colorLiteral(red: 0, green: 0.7176470588, blue: 0.8039215686, alpha: 1), highlighted: nil, selected: nil, disabled: #colorLiteral(red: 0.5607843137, green: 0.5607843137, blue: 0.5607843137, alpha: 1))
    }
}
