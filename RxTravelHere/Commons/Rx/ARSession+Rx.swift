//
//  ARSession+Rx.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2019/1/2.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

import ARKit
import RxSwift
import RxCocoa

class RXARSessionDelegateProxy: DelegateProxy<ARSession, ARSessionDelegate>, DelegateProxyType, ARSessionDelegate {
    
    private(set) var session: ARSession?
    
    private init(with session: ParentObject) {
        self.session = session
        super.init(parentObject: session, delegateProxy: RXARSessionDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RXARSessionDelegateProxy(with: $0) }
    }
    
    static func currentDelegate(for object: ARSession) -> ARSessionDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: ARSessionDelegate?, to object: ARSession) {
        object.delegate = delegate
    }
}

extension Reactive where Base: ARSession {
    var delegate: RXARSessionDelegateProxy {
        return RXARSessionDelegateProxy.proxy(for: base)
    }

    var didFail: Observable<Error> {
        let sel = #selector(ARSessionDelegate.session(_:didFailWithError:))
        return delegate.methodInvoked(sel).map {
            parameters in parameters[1] as! Error
        }
    }
    
    var interrupted: Observable<Void> {
        let sel = #selector(ARSessionDelegate.sessionWasInterrupted(_:))
        return delegate.methodInvoked(sel).map { _ in return () }
    }
    
    var interruptionEnded: Observable<Void> {
        let sel = #selector(ARSessionDelegate.sessionInterruptionEnded(_:))
        return delegate.methodInvoked(sel).map { _ in return () }
    }
    
    var cameraDidChangeTrackingState: Driver<ARCamera.TrackingState> {
        let sel = #selector(ARSessionDelegate.session(_:cameraDidChangeTrackingState:))
        return delegate.methodInvoked(sel).map {
            parameters in parameters[1] as! ARCamera.TrackingState
        }.asDriver(onErrorJustReturn: .notAvailable)
    }
    
    var cameraDidChangeNormal: Driver<Void> {
        let sel = #selector(ARSessionDelegate.session(_:cameraDidChangeTrackingState:))
        return delegate.methodInvoked(sel)
            .map { parameters in parameters[1] as! ARCamera }
            .map { $0.trackingState }
            .filter{ $0.isNormal }
            .map { _ in return () }
            .asDriver(onErrorJustReturn: ())
    }
    
//    var didUpdateFrame: Observable<ARFrame> {
//        // - (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame;
//        let sel = #selector(ARSessionDelegate.session(_:didUpdate:))
//        return delegate.methodInvoked(sel)
//            .map { parameters in parameters[1] as! ARFrame }
//    }
}

extension ARCamera.TrackingState {
    var isNormal: Bool {
        switch self {
        case .normal:
            return true
        default:
            return false
        }
    }
}
