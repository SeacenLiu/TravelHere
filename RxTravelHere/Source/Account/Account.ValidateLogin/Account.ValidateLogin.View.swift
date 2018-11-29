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
        
        // FIXME: - 这个不就是 Model 吗... View 不能接触Model   
        let phone: String
        
        init(phone: String) {
            self.phone = phone
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func loadView() {
            view = CodeView.nibView()
        }
        
        private lazy var _viewModel = ViewModel(
            phone: self.phone,
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
        
        _codeView.phoneLb.text = phone
        
        _viewModel.validatedCode
            .drive(_codeView.loginBtn.rx.isEnabled)
            .disposed(by: _disposeBag)
        
        _viewModel.login.drive(onNext: { result in
            switch result {
            case .sending:
                self.showHUD()
            case let .ok(data, msg):
                self.showHUD(successText: msg)
                log(data)
            case let .failed(err):
                self.showHUD(error: err)
            }
        }).disposed(by: _disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

final class CodeView: UIView {
    @IBOutlet weak var codeTf: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loginBtn.setColorInState(normal: #colorLiteral(red: 0, green: 0.7176470588, blue: 0.8039215686, alpha: 1), highlighted: nil, selected: nil, disabled: #colorLiteral(red: 0.5607843137, green: 0.5607843137, blue: 0.5607843137, alpha: 1))
    }
}
