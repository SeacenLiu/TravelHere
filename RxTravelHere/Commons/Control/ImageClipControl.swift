//
//  ImageClipControl.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/4.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImageClipControl {
    static func show(_ image: UIImage, hwRatio: CGFloat, isCycle: Bool, from: UIViewController?) -> Observable<YYImageClipViewController> {
        return Observable.create { [weak from] observer in
            let w = UIScreen.main.bounds.width
            let h = w * hwRatio
            let x: CGFloat = 0
            let y: CGFloat = (UIScreen.main.bounds.height - h) * 0.5
            let rect = CGRect(x: x, y: y, width: w, height: h)
            let cc = YYImageClipViewController(image: image, cropFrame: rect, limitScaleRatio: 3, isCycle: isCycle)!
            let cancelDispose = cc.rx.didCancel.subscribe(onNext: { _ in
                observer.onCompleted()
            })
            
            let doneDispose = cc.rx.didFinished.subscribe(onNext: { _ in
                observer.onCompleted()
            })
            
            guard let from = from else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            from.present(cc, animated: true)
            observer.onNext(cc)
            return Disposables.create(cancelDispose, doneDispose, Disposables.create {
                cc.dismiss(animated: true)
            })
        }
    }
    
    static func cropImage(_ image: UIImage, hwRatio: CGFloat, isCycle: Bool, from: UIViewController?) -> Observable<UIImage> {
        return self.show(image, hwRatio: hwRatio, isCycle: isCycle, from: from).debug()
            .flatMap { $0.rx.didFinished }
    }
}
