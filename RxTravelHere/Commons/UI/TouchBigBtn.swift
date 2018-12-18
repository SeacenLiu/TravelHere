//
//  TouchBigBtn.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/26.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class TouchBigBtn: UIButton {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !isUserInteractionEnabled || isHidden || alpha <= 0.01 {
            return nil
        }
        let touchRect = bounds.insetBy(dx: -10, dy: -10)
        if touchRect.contains(point) {
            for subView in subviews {
                let convertedPoint = subView.convert(point, to: self)
                let hitTestView = subView.hitTest(convertedPoint, with: event)
                if let v = hitTestView {
                    return v
                }
            }
            return self
        }
        return nil
    }

}
