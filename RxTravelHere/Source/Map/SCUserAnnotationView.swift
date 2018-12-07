//
//  SCUserAnnotationView.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/22.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

private let userReuseIndetifier = "userReuseIndetifier"

class SCUserAnnotationView: MAAnnotationView {
    
    class func userAnnotationView(_ mapView: MAMapView, _ userLocation: MAUserLocation) -> SCUserAnnotationView {
        var v: SCUserAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: userReuseIndetifier) as? SCUserAnnotationView
        if v == nil {
            v = SCUserAnnotationView(annotation: userLocation, reuseIdentifier: userReuseIndetifier)
        }
        
        v!.image = #imageLiteral(resourceName: "userLocation_icon")
        
        // 设置为NO，用以调用自定义的calloutView
        v!.canShowCallout = false
        
        v!.centerOffset = CGPoint(x: 0, y: -18)
        return v!
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
