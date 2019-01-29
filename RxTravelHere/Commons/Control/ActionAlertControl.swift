//
//  ActionAlertControl.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2019/1/29.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ActionAlertControl {
    static func showWithTextField(from: UIViewController?, title: String? = nil, text: String? = nil) -> Observable<String> {
        return Observable.create({ [weak from] observer in
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (tf) in
                tf.clearButtonMode = .whileEditing
                tf.text = text
            })
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
                if let newName = alert.textFields?.first?.text {
                    if newName != text {
                        observer.onNext(newName)
                    }
                    observer.onCompleted()
                }
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
                observer.onCompleted()
            }))
            guard let from = from else {
                observer.onCompleted()
                return Disposables.create()
            }
            from.present(alert, animated: true)
            return Disposables.create {
                alert.dismiss(animated: true)
            }
        })
    }
}
