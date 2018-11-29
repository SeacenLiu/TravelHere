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

//extension Account.Login {

//
//    final class CodeController: UIViewController {
//        private var _codeView: CodeView { return view as! CodeView }
//
//        override func loadView() {
//            view = CodeView.nibView()
//        }
//    }
//}
//
//extension Account.Login.PhoneController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        _viewModel.validatedPhone.drive(_phoneView.nextBtn.rx.isEnabled).disposed(by: _diposeBag)
//
//        _phoneView.nextBtn.rx
//            .controlEvent(.touchUpInside)
//            .subscribe(onNext: {
//                log("here")
////                self.navigationController?.pushViewController(Account.Login.CodeController(), animated: true)
//            }).disposed(by: _diposeBag)
//    }
//}
//
//
//final class CodeView: UIView {
//
//}
//
//extension Account.Login {
//    class PhoneViewModel {
//        let validatedPhone: Driver<Bool>
//
//        init(input:(phone: Driver<String>, sendTaps: Signal<()>)) {
//            validatedPhone = input.phone.map { $0.count == 11 }
//        }
//    }
//
//    class CodeViewModel {
//        let validatedCode: Driver<Bool>
//
//        init(input:(code: Driver<String>, loginTaps: Signal<()>)) {
//            validatedCode = input.code.map { $0.count == 4 }
//        }
//    }
//}
