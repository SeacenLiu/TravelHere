//
//  UILabel+Ex.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/27.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String, systemFont: CGFloat, textColor: UIColor) {
        self.init()
        self.text = text
        self.font = UIFont.systemFont(ofSize: systemFont)
        self.textColor = textColor
    }
}
