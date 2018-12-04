//
//  KingfisherControl.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/4.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class KingfisherControl {
    static func getImage(with urlStr: String, placeholder: String) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer -> Disposable in
            if let url = URL(string: urlStr) {
                KingfisherManager.shared.retrieveImage(
                    with: url,
                    options: [],
                    progressBlock: nil,
                    completionHandler: { (image, error, _, _) in
                        if let err = error {
                            observer.onError(err)
                        } else {
                            observer.onNext(image ?? UIImage(named: placeholder)!)
                            observer.onCompleted()
                        }
                })
            } else {
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    enum KFError: Error {
        case urlError
    }
}
