//
//  UIImagePickerController+Rx.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/3.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class RxImagePickerDelegateProxy: RxNavigationControllerDelegateProxy, UIImagePickerControllerDelegate {
    
    public init(imagePicker: UIImagePickerController) {
        super.init(navigationController: imagePicker)
    }
    
}

extension Reactive where Base: UIImagePickerController {

    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey : Any]> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
//            .do(onNext: { _ in self.base.dismiss(animated: true) })
            .map({ (a) in
                return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, Any>.self, a[1])
            })
    }

    public var didCancel: Observable<()> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }

}

fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
