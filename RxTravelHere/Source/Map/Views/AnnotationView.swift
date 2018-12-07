//
//  AnnotationView.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/7.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

class AnnotationView: MAAnnotationView {
    
    static let reuseIndetifier = "com.Seacen.Map.AnnotationView.reuseIndetifier"
    
    class func annotationView(_ mapView: MAMapView, _ annotation: Map.Show.Model) -> AnnotationView {
        var v: AnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIndetifier) as? AnnotationView
        if v == nil {
            v = AnnotationView(annotation: annotation, reuseIdentifier: reuseIndetifier)
        }
        guard let view = v else { fatalError("Map.AnnotationView加载失败") }
        view.isUserInteractionEnabled = false
        view.image = annotation.type.image
        view.centerOffset = CGPoint(x: 0, y: -18)
        return view
    }
    
}

