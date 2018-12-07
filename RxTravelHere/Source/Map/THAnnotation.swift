//
//  THAnnotation.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/22.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class THAnnotation: MAPointAnnotation {
    let type: THRecordType
    init(type: THRecordType) {
        self.type = type
        super.init()
    }
}
