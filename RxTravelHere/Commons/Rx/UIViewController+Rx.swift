//
//  UIViewController+Rx.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/20.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var dismissAction: AnyObserver<Void> {
        return Binder<Void>(base) { c, _ in
            c.dismiss(animated: true)
        }.asObserver()
    }
    
    var endEditing: AnyObserver<Void> {
        return Binder<Void>(base) { c, _ in
            c.view.endEditing(true)
        }.asObserver()
    }
}
