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
    static func show(from: UIViewController, menu: [String], title: String? = nil) -> Observable<Int> {
        return Observable.create({ [unowned from] subcriber in
            let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            for (index, actionTitle) in menu.enumerated() {
                let action = UIAlertAction(title: actionTitle, style: .default, handler: { _ in
                    subcriber.onNext(index)
                })
                actionSheet.addAction(action)
            }
            actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                subcriber.onCompleted()
            }))
            from.present(actionSheet, animated: true)
            return Disposables.create {
                actionSheet.dismiss(animated: true)
            }
        })
    }
}
