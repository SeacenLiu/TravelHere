//
//  THInputView+Rx.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/27.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RxInputViewDelegateProxy: DelegateProxy<THInputView, THInputViewDelegate>, DelegateProxyType, THInputViewDelegate {
    
    weak private(set) var inputView: THInputView?
    
    init(inputView: ParentObject) {
        self.inputView = inputView
        super.init(parentObject: inputView, delegateProxy: RxInputViewDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxInputViewDelegateProxy(inputView: $0) }
    }
    
    static func currentDelegate(for object: THInputView) -> THInputViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: THInputViewDelegate?, to object: THInputView) {
        object.delegate = delegate
    }
}

extension Reactive where Base: THInputView {
    var delegate: RxInputViewDelegateProxy {
        return RxInputViewDelegateProxy.proxy(for: base)
    }
    
    /// 点击回车的发送操作
    var clickEnter: Observable<(String)> {
        let sel = #selector(THInputViewDelegate.inPuterDidEnter(inputView:text:))
        return delegate.methodInvoked(sel).map {
            parameters in parameters[1] as! String
        }
    }
    
    /// frame变化
    var frameChange: Observable<(CGRect)> {
        let sel = #selector(THInputViewDelegate.inPuterFrameDidChange(inputView:frame:))
        return delegate.methodInvoked(sel).map {
            parameters in parameters[1] as! CGRect
        }
    }
}

extension Reactive where Base: THInputView {
    var dismiss: AnyObserver<Void> {
        return Binder<Void>(base) { v, _ in
            v.dismiss()
        }.asObserver()
    }
}
