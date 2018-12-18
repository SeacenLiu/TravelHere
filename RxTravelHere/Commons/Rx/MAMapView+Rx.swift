//
//  MAMapView+Rx.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/7.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RxMapViewDelegateProxy: DelegateProxy<MAMapView, MAMapViewDelegate>, DelegateProxyType, MAMapViewDelegate {
    
    weak private(set) var mapView: MAMapView?
    
    init(mapView: ParentObject) {
        self.mapView = mapView
        super.init(parentObject: mapView, delegateProxy: RxMapViewDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxMapViewDelegateProxy(mapView: $0) }
    }
    
    static func currentDelegate(for object: MAMapView) -> MAMapViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: MAMapViewDelegate?, to object: MAMapView) {
        object.delegate = delegate
    }
    
//    override open func setForwardToDelegate(_ delegate: MAMapViewDelegate?, retainDelegate: Bool) {
//        super.setForwardToDelegate(delegate, retainDelegate: false)
//    }
    
    // 现在只有一个地图，暂且放这里，首页就不需要写代理了
    private var userView: MAAnnotationView?

    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        log("viewFor in `RxMapViewDelegateProxy`")
        if let annotation = annotation as? MAUserLocation {
            let annotationView = UserAnnotationView.userAnnotationView(mapView, annotation)
            DispatchQueue.main.async {
                mapView.selectAnnotation(annotation, animated: false)
            }
            userView = annotationView
            return annotationView
        }
        if let annotation = annotation as? Home.Annotation {
            let annotationView = AnnotationView.annotationView(mapView, annotation)
            // mapView的第二个子视图是 MAAnnotationContainerView
            if let userView = userView {
                mapView.subviews[1].bringSubviewToFront(userView)
            }
            return annotationView
        }
        return nil
    }
}

extension Reactive where Base: MAMapView {
    var delegate: RxMapViewDelegateProxy {
        return RxMapViewDelegateProxy.proxy(for: base)
    }
    
    /// 地图开始加载
    var willStartLoadingMap: Observable<()> {
        let sel = #selector(MAMapViewDelegate.mapViewWillStartLoadingMap(_:))
        return delegate.methodInvoked(sel).map {_ in ()}
    }
    
    /// 地图加载成功
    var didFinishLoadingMap: Observable<()> {
        let sel = #selector(MAMapViewDelegate.mapViewDidFinishLoadingMap(_:))
        return delegate.methodInvoked(sel).map {_ in ()}
    }
    
    /// 地图加载失败
    var didFailLoadingMap: Observable<NSError> {
        let sel = #selector(MAMapViewDelegate.mapViewDidFailLoadingMap(_:withError:))
        return delegate.methodInvoked(sel).map {
            parameters in parameters[1] as! NSError
        }
    }
    
    /// 更新设备位置或方向
    var didUpdateUserLocation: Observable<MAUserLocation> {
        let sel = #selector(MAMapViewDelegate.mapView(_:didUpdate:updatingLocation:))
        return delegate.methodInvoked(sel)
            .filter{ parameters in parameters[2] as! Bool == true }
            .map {
                parameters in parameters[1] as! MAUserLocation
        }
    }
    
    /// 定位失败
    var didFailToLocateUser: Observable<NSError> {
        let sel = #selector(MAMapViewDelegate.mapView(_:didFailToLocateUserWithError:))
        return delegate.methodInvoked(sel).map {
            parameters in parameters[1] as! NSError
        }
    }
}
