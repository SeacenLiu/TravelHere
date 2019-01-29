//
//  UIView+Ex.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/28.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

extension UIView {
    class var className: String {
        let name =  self.description()
        if(name.contains(".")){
            return name.components(separatedBy: ".")[1];
        }else{
            return name;
        }
    }
    
    class func nibView() -> UIView {
        let nib = UINib(nibName: className, bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! UIView
        return v
    }
}

extension UIView {
    convenience init(color: UIColor) {
        self.init(frame: .zero)
        backgroundColor = color
    }
}
