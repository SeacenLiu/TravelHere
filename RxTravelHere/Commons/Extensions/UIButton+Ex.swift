//
//  UIButton+Ex.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/20.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

extension UIButton {
    public func setColorInState(normal: UIColor?, highlighted: UIColor?, selected: UIColor?, disabled: UIColor?) {
        if let normal = normal {
            setBackgroundImage(UIImage.createImage(color: normal, rect: bounds), for: .normal)
        }
        if let highlighted = highlighted {
            setBackgroundImage(UIImage.createImage(color: highlighted, rect: bounds), for: .highlighted)
        }
        if let selected = selected {
            setBackgroundImage(UIImage.createImage(color: selected, rect: bounds), for: .selected)
        }
        if let disabled = disabled {
            setBackgroundImage(UIImage.createImage(color: disabled, rect: bounds), for: .disabled)
        }
    }
}
