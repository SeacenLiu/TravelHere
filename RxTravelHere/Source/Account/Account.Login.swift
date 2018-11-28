//
//  Account.Login.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/28.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Account.Login {
    final class PhoneController: UIViewController {
        private var _phoneView: PhoneView { return view as! PhoneView }
        let _diposeBag = DisposeBag()
        override func loadView() {
            view = PhoneView.nibView()
        }
        private lazy var _viewModel = PhoneViewModel(
            input: (
                phone: self._phoneView.phoneTf.rx.text.orEmpty.asDriver(),
                sendTaps: self._phoneView.nextBtn.rx.tap.asSignal()
            )
        )
    }
    
    final class CodeController: UIViewController {
        private var _codeView: CodeView { return view as! CodeView }
        
        override func loadView() {
            view = CodeView.nibView()
        }
    }
}

extension Account.Login.PhoneController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _viewModel.validatedPhone.drive(_phoneView.nextBtn.rx.isEnabled).disposed(by: _diposeBag)
        
        _phoneView.nextBtn.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: {
                log("here")
//                self.navigationController?.pushViewController(Account.Login.CodeController(), animated: true)
            }).disposed(by: _diposeBag)
    }
}

final class PhoneView: UIView {
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var phoneTf: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nextBtn.setColorInState(normal: #colorLiteral(red: 0, green: 0.7176470588, blue: 0.8039215686, alpha: 1), highlighted: nil, selected: nil, disabled: #colorLiteral(red: 0.5607843137, green: 0.5607843137, blue: 0.5607843137, alpha: 1))
    }
}

final class CodeView: UIView {
    
}

extension Account.Login {
    class PhoneViewModel {
        let validatedPhone: Driver<Bool>
        
        init(input:(phone: Driver<String>, sendTaps: Signal<()>)) {
            validatedPhone = input.phone.map { $0.count == 11 }
        }
    }
    
    class CodeViewModel {
        let validatedCode: Driver<Bool>
        
        init(input:(code: Driver<String>, loginTaps: Signal<()>)) {
            validatedCode = input.code.map { $0.count == 4 }
        }
    }
}
