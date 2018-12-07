//
//  Map.Show.Model.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/5.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

extension Map.Show {
    class Model: MAPointAnnotation {
        let type: Record.Style
        
        init(type: Record.Style) {
            self.type = type
            super.init()
        }
    }
}
