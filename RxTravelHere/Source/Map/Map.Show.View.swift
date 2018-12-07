//
//  Map.Show.View.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/5.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Map.Show {
    final class View: UIViewController {
        private var _mapView: MapView { return view as! MapView }
        let _diposeBag = DisposeBag()
        
        override func loadView() {
            view = MapView.nibView()
        }
        
        /// 地图
        private lazy var mapView = MAMapView(
            bundle: "MapSetting",
            frame: self.view.bounds,
            delegate: self
        )
        
        private lazy var locationManager = CLLocationManager(delegate: self)
    }
}

extension Map.Show.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        checkLocationAuthorization()
    }
    
    func setupUI() {
        view.insertSubview(mapView, at: 0)
        // 用户位置显示
        let r = MAUserLocationRepresentation()
        r.showsAccuracyRing = false
        mapView.update(r)
        // 默认的视角
        mapView.setDefaultVisual()
    }
}

extension Map.Show.View: MAMapViewDelegate {
    func mapViewWillStartLocatingUser(_ mapView: MAMapView!) {
        log("地图即将开启定位")
    }

    func mapView(_ mapView: MAMapView!, didFailToLocateUserWithError error: Error!) {
        log("地图定位失败")
        tipChangePrivilege(privilege: .location)
        log("添加模糊")

    }

    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        log("点击的位置: \(coordinate)")
    }

    func mapViewDidStopLocatingUser(_ mapView: MAMapView!) {
        log("地图停止定位")
    }
}

extension Map.Show.View: CLLocationManagerDelegate {
    func checkLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .followWithHeading
        } else if CLLocationManager.authorizationStatus() != .notDetermined  {
            tipChangePrivilege(privilege: .location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            log("authorizedWhenInUse")
        case .denied:
            log("denied")
        default:
            break
        }
    }
}
