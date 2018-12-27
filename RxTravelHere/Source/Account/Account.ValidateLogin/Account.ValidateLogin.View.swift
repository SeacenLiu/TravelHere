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
        
        let showViewModel: ShowViewModel
        
        init(viewModel: ShowViewModel) {
            showViewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func loadView() {
            view = CodeView.nibView()
        }
        
        private lazy var _viewModel = ViewModel(
            phone: showViewModel.phoneNum,
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
        
        setupUI()
        
        _viewModel.validatedCode
            .drive(_codeView.loginBtn.rx.isEnabled)
            .disposed(by: _disposeBag)
        
        _viewModel.login
            .drive(rx.showEditView)
            .disposed(by: _disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupUI() {
        _codeView.phoneLb.text = showViewModel.phoneNum
    }
    
    fileprivate func showCodeError() {
        UIView.animate(withDuration: 0.25, animations: {
            self._codeView.errorToast.alpha = 1
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                UIView.animate(withDuration: 0.25, animations: {
                    self._codeView.errorToast.alpha = 0
                })
            })
        }
    }
}

extension Reactive where Base: Account.ValidateLogin.View {
    var showEditView: AnyObserver<Bool> {
        return Binder<Bool>(base) { c, v in
            if v {
                c.showHUD(successText: "登录成功")
                c.navigationController?.pushViewController(
                    Account.Edit.View(),
                    animated: true)
            } else {
                c.showCodeError()
            }
        }.asObserver()
    }
}

final class CodeView: UIView {
    @IBOutlet weak var codeTf: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneLb: UILabel!
    // TODO: - 需要一个正常的 Toast
    @IBOutlet weak var errorToast: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loginBtn.setColorInState(normal: #colorLiteral(red: 0, green: 0.7176470588, blue: 0.8039215686, alpha: 1), highlighted: nil, selected: nil, disabled: #colorLiteral(red: 0.5607843137, green: 0.5607843137, blue: 0.5607843137, alpha: 1))
    }
}
