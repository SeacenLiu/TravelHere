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
import AVFoundation.AVCaptureDevice
import AVFoundation.AVMediaFormat

class ImagePickerControl {
    static func show(from: UIViewController, sourceType: UIImagePickerController.SourceType) -> Observable<UIImagePickerController> {
        return Observable<UIImagePickerController>.create { [unowned from] subscribe in
            let picker = UIImagePickerController()
            let cancelDisposable = picker.rx
                .didCancel
                .subscribe(onNext: { _ in
                    subscribe.onCompleted()
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
        return self.checkPrivilege(from: from, sourceType: sourceType)
            .flatMap { f, t in self.show(from: f, sourceType: t) }
            .flatMap { picker in picker.rx.didFinishPickingMediaWithInfo }
            .map { info in info[UIImagePickerController.InfoKey.originalImage] as? UIImage }
    }
    
    static func checkPrivilege(from: UIViewController, sourceType: UIImagePickerController.SourceType) -> Observable<(UIViewController, UIImagePickerController.SourceType)> {
        return Observable<(UIViewController, UIImagePickerController.SourceType)>.create({ subscriber -> Disposable in
            var hasPrivilege = true
            var privilege: Privilege = .camera
            switch sourceType {
            case .camera:
                let videoStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                if videoStatus == .authorized {
                    log("有相机权限")
                } else if videoStatus != .notDetermined {
                    privilege = .camera
                    hasPrivilege = false
                    break
                }
                let audioStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
                if audioStatus == .authorized {
                    log("有麦克风权限")
                } else if audioStatus != .notDetermined  {
                    privilege = .microphone
                    hasPrivilege = false
                    break
                }
                if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                    log("无可用摄像头")
                    subscriber.onCompleted()
                }
            case .savedPhotosAlbum:
                break
            default:
                subscriber.onCompleted()
            }
            
            let aleat = UIAlertController(title: "", message:privilege.rawValue, preferredStyle: .alert)
            if hasPrivilege {
                subscriber.onNext((from, sourceType))
            } else {
                let tempAction = UIAlertAction(title: "取消", style: .cancel) { _ in
                    subscriber.onCompleted()
                }
                let callAction = UIAlertAction(title: "立即设置", style: .default) { _ in
                    let url = NSURL.init(string: UIApplication.openSettingsURLString)
                    if(UIApplication.shared.canOpenURL(url! as URL)) {
                        UIApplication.shared.open(url! as URL, options: [:])
                    }
                    subscriber.onCompleted()
                }
                aleat.addAction(tempAction)
                aleat.addAction(callAction)
                from.present(aleat, animated: true, completion: nil)
            }
            
            return Disposables.create {
                aleat.dismiss(animated: true)
            }
        })
    }
}

extension ImagePickerControl {
    enum Privilege: String {
        case location = "定位服务未开启,请进入系统设置>隐私>定位服务中打开开关,并允许\"到此一游\"使用定位服务"
        case album = "相册服务未开启,请进入系统设置>隐私>照片中打开开关,并允许\"到此一游\"使用相册"
        case camera = "相机服务未开启,请进入系统设置>隐私>相机中打开开关,并允许\"到此一游\"使用相机"
        case microphone = "麦克风服务未开启,请进入系统设置>隐私>麦克风中打开开关,并允许\"到此一游\"使用麦克风"
    }
}
