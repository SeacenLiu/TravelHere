//
//  CLLocationManager+Ex.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/7.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

extension CLLocationManager {
    convenience init(delegate: CLLocationManagerDelegate) {
        self.init()
        self.delegate = delegate
    }
}
