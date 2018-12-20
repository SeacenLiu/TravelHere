//
//  ActionSheetControl.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/3.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ActionSheetControl {
    static func show(from: UIViewController?, menu: [String], title: String? = nil) -> Observable<Int> {
        return Observable.create({ [weak from] observer in
            let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            for (index, actionTitle) in menu.enumerated() {
                let action = UIAlertAction(title: actionTitle, style: .default, handler: { _ in
                    observer.onNext(index)
                    observer.onCompleted()
                })
                actionSheet.addAction(action)
            }
            actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                observer.onCompleted()
            }))
            
            guard let from = from else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            from.present(actionSheet, animated: true)
            return Disposables.create {
                actionSheet.dismiss(animated: true)
            }
        })
    }
}
