//
//  View.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

extension Account.PhoneLogin {
    final class View: UIViewController {
        private var _phoneView: PhoneView { return view as! PhoneView }
        let _diposeBag = DisposeBag()
        override func loadView() {
            view = PhoneView.nibView()
        }
//        private lazy var _viewModel = PhoneViewModel(
//            input: (
//                phone: self._phoneView.phoneTf.rx.text.orEmpty.asDriver(),
//                sendTaps: self._phoneView.nextBtn.rx.tap.asSignal()
//            )
//        )
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
