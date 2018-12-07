//
//  UserAnnotationView.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/7.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

class UserAnnotationView: MAAnnotationView {
    static let reuseIndetifier = "com.Seacen.Map.Show.UserView.ReuseIndetifier"
    
    class func userAnnotationView(_ mapView: MAMapView, _ userLocation: MAUserLocation) -> UserAnnotationView {
        var v: UserAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: UserAnnotationView.reuseIndetifier) as? UserAnnotationView
        if v == nil {
            v = UserAnnotationView(annotation: userLocation, reuseIdentifier: UserAnnotationView.reuseIndetifier)
        }
        guard let userView = v else { fatalError("Map.Show.UserView加载失败") }
        userView.image = #imageLiteral(resourceName: "userLocation_icon")
        userView.canShowCallout = false
        userView.centerOffset = CGPoint(x: 0, y: -18)
        return userView
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        startAnimate()
    }
    
    private func startAnimate() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 2.2
        animation.autoreverses = true
        animation.duration = 1.0
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        circlrView.add(animation, forKey: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.isSelected == selected { return }
        if selected && animated {
            self.imageView.alpha = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.setSelected(false, animated: animated)
            }
        } else {
            self.imageView.alpha = 1
        }
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - lazy
    private lazy var circlrView: CALayer = {
        let lr = CALayer()
        lr.frame = CGRect(x: 0, y: 0, width: self.bounds.width+6, height: self.bounds.height+6)
        lr.position = self.imageView.center
        lr.backgroundColor = UIColor.white.cgColor
        lr.cornerRadius = lr.frame.width * 0.5
        lr.opacity = 0.5
        self.layer.insertSublayer(lr, below: self.imageView.layer)
        return lr
    }()
    
}

