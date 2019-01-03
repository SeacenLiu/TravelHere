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
    
}

extension Reactive where Base: MAMapView {
    public func setDelegate(_ delegate: MAMapViewDelegate)
        -> Disposable {
            return RxMapViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
    
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
