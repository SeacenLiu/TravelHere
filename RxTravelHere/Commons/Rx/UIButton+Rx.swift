//
//  UIButton+Rx.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/3.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

extension Reactive where Base: UIButton {
    var kfBackgroundImage: AnyObserver<String> {
        return Binder<String>(base) { btn, urlStr in
            let url = URL(string: urlStr)
            let placeholder = UIImage(named: "big_user_icon")
            btn.kf.setBackgroundImage(with: url, for: .normal, placeholder: placeholder)
        }.asObserver()
    }
}
