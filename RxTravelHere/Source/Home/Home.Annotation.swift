//
//  Home.Annotation.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/5.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

extension Home {
    internal class Annotation: MAPointAnnotation {
        let type: Record.Style
        
        init(type: Record.Style, latitude: Double, longitude: Double) {
            self.type = type
            super.init()
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        override var description: String {
            return "{type: \(type), longitude: \(coordinate.longitude), latitude: \(coordinate.latitude)}"
        }
    }
}
