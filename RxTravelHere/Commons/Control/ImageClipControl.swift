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
    static func show(_ image: UIImage, isCycle: Bool, from: UIViewController) -> Observable<YYImageClipViewController> {
        return Observable.create { subscriber in
            let w = UIScreen.main.bounds.width
            let h = w //  * imagescaleHW
            let x: CGFloat = 0
            let y: CGFloat = (UIScreen.main.bounds.height - h) * 0.5
            let rect = CGRect(x: x, y: y, width: w, height: h)
            let cc = YYImageClipViewController(image: image, cropFrame: rect, limitScaleRatio: 3, isCycle: isCycle)!
            let cancelDispose = cc.rx.didCancel.subscribe(onNext: { _ in
                cc.dismiss(animated: true)
            })
            log(from)
            from.present(cc, animated: true)
            subscriber.onNext(cc)
            return Disposables.create(cancelDispose, Disposables.create {
                cc.dismiss(animated: true)
            })
        }
    }
    
    static func cropImage(_ image: UIImage, isCycle: Bool, from: UIViewController) -> Observable<UIImage> {
        return self.show(image, isCycle: isCycle, from: from)
            .flatMap { $0.rx.didFinished }
    }
}
