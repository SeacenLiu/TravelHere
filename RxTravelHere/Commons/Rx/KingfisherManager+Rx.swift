//
//  KingfisherManager+Rx.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/25.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import Kingfisher
import RxSwift

extension KingfisherManager: ReactiveCompatible { }

extension Reactive where Base: KingfisherManager {
    func loadImage(with resource: Resource) -> Observable<UIImage> {
        return Observable.create({ observer in
            self.base.retrieveImage(
                with: resource,
                options: nil,
                progressBlock: nil,
                completionHandler: { (image, error, type, _) in
                    if let err = error {
                        observer.onError(err)
                    } else if let img = image {
                        observer.onNext(img)
                    }
                    observer.onCompleted()
            })
            return Disposables.create()
        })
    }
}

