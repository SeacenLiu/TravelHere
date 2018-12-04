//
//  ImagePickerControl.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/4.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImagePickerControl {
    static func show(from: UIViewController, sourceType: UIImagePickerController.SourceType) -> Observable<UIImagePickerController> {
        return Observable<UIImagePickerController>.create { [unowned from] subscribe in
            let picker = UIImagePickerController()
            let cancelDisposable = picker.rx
                .didCancel
                .subscribe(onNext: { _ in
                    picker.dismiss(animated: true)
                })
            picker.sourceType = sourceType
            from.present(picker, animated: true)
            subscribe.onNext(picker)
            return Disposables.create(cancelDisposable, Disposables.create {
                picker.dismiss(animated: true)
                }
            )
        }
    }
    
    static func showActionAndGetImage(from: UIViewController) -> Observable<UIImage?> {
        return ActionSheetControl
            .show(from: from, menu: ["来自相机", "来自相册"])
            .flatMap { (which) -> Observable<UIImage?> in
                var source: UIImagePickerController.SourceType = .camera
                if which == 1 { source = .savedPhotosAlbum }
                return ImagePickerControl.showAndGetImage(from: from, sourceType: source)
        }
    }
    
    static func showAndGetImage(from: UIViewController, sourceType: UIImagePickerController.SourceType) -> Observable<UIImage?> {
        return self.show(from: from, sourceType: sourceType)
            .flatMap { picker in
                return picker.rx.didFinishPickingMediaWithInfo
            }
            .map { info in
                return info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
    }
}
