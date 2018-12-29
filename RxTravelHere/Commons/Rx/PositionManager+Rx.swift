//
//  PositionManager+Rx.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension PositionManager: ReactiveCompatible { }

extension Reactive where Base: PositionManager {
    var location: AnyObserver<CLLocationCoordinate2D> {
        return Binder<CLLocationCoordinate2D>(base) { m, l in
            m.changeCurrent(coordinate: l)
        }.asObserver()
    }
}
