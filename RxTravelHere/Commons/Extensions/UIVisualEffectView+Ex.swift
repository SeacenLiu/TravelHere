//
//  UIVisualEffectView+Ex.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2019/1/2.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

import UIKit

extension UIVisualEffectView {
    convenience init(style: UIBlurEffect.Style, frame: CGRect) {
        let effect = UIBlurEffect(style: style)
        self.init(effect: effect)
        self.frame = UIScreen.main.bounds
    }
}
