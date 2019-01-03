//
//  CLLocationManager+Rx.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RxLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    private(set) var manager: CLLocationManager?
    
    private init(manager: ParentObject) {
        self.manager = manager
        super.init(parentObject: manager, delegateProxy: RxLocationManagerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxLocationManagerDelegateProxy(manager: $0) }
    }
    
    public static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
        object.delegate = delegate
    }
}

extension Reactive where Base: CLLocationManager {
    var delegate: RxLocationManagerDelegateProxy {
        return RxLocationManagerDelegateProxy.proxy(for: base)
    }
    
    public var didChangeAuthorization: Observable<CLAuthorizationStatus> {
        let sel = #selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:))
        return delegate.methodInvoked(sel)
            .map { parameters in parameters[1] as! CLAuthorizationStatus }
    }
}
