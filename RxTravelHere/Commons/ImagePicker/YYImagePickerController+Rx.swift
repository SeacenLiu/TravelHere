//
//  YYImagePickerController+Rx.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/4.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//extension YYImageClipViewController: HasDelegate {
//    public typealias Delegate = YYImageClipDelegate
//}

class RxImageClipViewControllerDelegateProxy
    : DelegateProxy<YYImageClipViewController, YYImageClipDelegate>
    , DelegateProxyType
    , YYImageClipDelegate {
    
    public static func currentDelegate(for object: YYImageClipViewController) -> YYImageClipDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: YYImageClipDelegate?, to object: YYImageClipViewController) {
        object.delegate = delegate
    }
    
    /// Typed parent object.
    public weak private(set) var imageClipController: YYImageClipViewController?
    
    /// - parameter imageClipController: Parent object for delegate proxy.
    public init(imageClipController: ParentObject) {
        self.imageClipController = imageClipController
        super.init(parentObject: imageClipController, delegateProxy: RxImageClipViewControllerDelegateProxy.self)
    }
    
    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxImageClipViewControllerDelegateProxy(imageClipController: $0) }
    }
}

extension Reactive where Base: YYImageClipViewController {
    var delegate: RxImageClipViewControllerDelegateProxy {
        return RxImageClipViewControllerDelegateProxy.proxy(for: base)
    }
    
    public var didFinished: Observable<UIImage> {
        let sel = #selector(YYImageClipDelegate.imageCropper(_:didFinished:))
        return delegate.methodInvoked(sel)
            .do(onNext: { _ in self.base.dismiss(animated: true) })
            .map {
            parameters in parameters[1] as! UIImage
        }
    }
    
    public var didCancel: Observable<()> {
        let sel = #selector(YYImageClipDelegate.imageCropperDidCancel(_:))
        return delegate.methodInvoked(sel).map {_ in () }
    }
}
