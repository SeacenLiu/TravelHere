//
//  UIButton+Ex.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/20.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(image: UIImage) {
        self.init()
        self.setImage(image, for: .normal)
    }
    
    convenience init(title: String, titleColor: UIColor, fontSize: CGFloat) {
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        sizeToFit()
    }
}

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
