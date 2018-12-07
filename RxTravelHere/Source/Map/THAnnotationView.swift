//
//  THAnnotationView.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/22.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

private let pointReuseIndetifier = "pointReuseIndetifier"

class THAnnotationView: MAAnnotationView {

    class func annotationView(_ mapView: MAMapView, _ annotation: THAnnotation) -> THAnnotationView {
        
        var v: THAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? THAnnotationView
        
        if v == nil {
            v = THAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
        }
        
        v?.isUserInteractionEnabled = false
        
        var image: UIImage?
        switch annotation.type {
            case .heart:
            image = #imageLiteral(resourceName: "map_heart")
        case .note:
            image = #imageLiteral(resourceName: "map_note")
        case .blackboard:
            image = #imageLiteral(resourceName: "map_blackboard")
        }
        v!.image = image
        
        v!.centerOffset = CGPoint(x: 0, y: -18)
        return v!
    }

}
