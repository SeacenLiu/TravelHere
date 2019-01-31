//
//  LPSliderView+Rx.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2019/1/31.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: LPSliderView {
    var redPoints: AnyObserver<[Int]> {
        return Binder<[Int]>(base) { v, array in
            v.redPoints = array
        }.asObserver()
    }
}
