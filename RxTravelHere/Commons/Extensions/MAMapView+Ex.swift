//
//  MAMapView+Ex.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/7.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

extension MAMapView {
    convenience init(bundle: String, frame: CGRect, delegate: MAMapViewDelegate) {
        self.init(frame: frame)
        self.delegate = delegate
        customizeUserLocationAccuracyCircleRepresentation = true
        if var path = Bundle.main.path(forResource: bundle, ofType: "bundle", inDirectory: nil) {
            path += "/style.data"
            if let data = NSData(contentsOfFile: path) {
                setCustomMapStyleWithWebData(data as Data?)
            }
        } else {
            fatalError("地图样式加载失败")
        }
        isShowsLabels = false
        isShowsBuildings = false
        customMapStyleEnabled = true
        showsCompass = false
        showsScale = false
        isZoomEnabled = false
        isScrollEnabled = false
        isRotateEnabled = false
        isRotateCameraEnabled = false
    }
}

extension MAMapView {
    func setDefaultVisual() {
        setZoomLevel(20, animated: true)
        setCameraDegree(90, animated: false, duration: 0.25)
    }
}
