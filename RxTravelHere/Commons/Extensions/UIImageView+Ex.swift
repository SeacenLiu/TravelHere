//
//  UIImageView+Ex.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/27.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

extension UIImageView {
    convenience init(side: CGFloat, img: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: side, height: side))
        image = UIImage(named: img)
        layer.cornerRadius = side * 0.5
        layer.masksToBounds = true
    }
    
    convenience init(imageName: String, radius: CGFloat? = 0) {
        self.init(frame: .zero)
        image = UIImage(named: imageName)
        if let radius = radius {
            layer.cornerRadius = radius
            layer.masksToBounds = true
        }
        sizeToFit()
    }
}
