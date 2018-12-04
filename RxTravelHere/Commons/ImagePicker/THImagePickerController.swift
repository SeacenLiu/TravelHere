//
//  THImagePickerController.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/17.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit
import AVFoundation.AVCaptureDevice
import AVFoundation.AVMediaFormat

class THImagePickerController: UIImagePickerController {
    
    typealias THImgPickerCallBack = (_ image: UIImage)->()
    
    convenience init(handleVC: UIViewController, imagescaleHW: CGFloat, isCycle: Bool, callBack: @escaping THImgPickerCallBack) {
        self.init()
        self.imagescaleHW = imagescaleHW
        self.isCycle = isCycle
        self.callBack = callBack
        self.handleVC = handleVC
    }
    
    public func selectImg() {
        let alertVc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "从相机中选择", style: .default) { (_) in
            self.showPhotoLibraryVC()
        }
        alertVc.addAction(action1)
        let action2 = UIAlertAction(title: "拍照", style: .default) { (_) in
            self.showCameraPickerVC()
        }
        alertVc.addAction(action2)
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        alertVc.addAction(cancel)
        handleVC?.present(alertVc, animated: true)
    }
    
    private var callBack: THImgPickerCallBack?
    private weak var handleVC: UIViewController?
    private var isCycle = false
    private var imagescaleHW: CGFloat = 1.0
    
    deinit {
        log("THImagePickerController deinit")
    }
}

extension THImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate,YYImageClipDelegate {
    private func showPhotoLibraryVC() {
        sourceType = .photoLibrary
        delegate = self
        handleVC?.showDetailViewController(self, sender: nil)
    }
    
    private func showCameraPickerVC() {
        // 检查相机权限
        let videoStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if videoStatus == .authorized {
            log("有相机权限")
        }
        else if videoStatus != .notDetermined  {
            handleVC?.tipChangePrivilege(privilege: .camera)
            return
        }
        // 检查麦克风权限
        let audioStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        if audioStatus == .authorized {
            log("有麦克风权限")
        }
        else if audioStatus != .notDetermined  {
            handleVC?.tipChangePrivilege(privilege: .microphone)
            return
        }
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            log("无可用摄像头")
            return
        }
        sourceType = .camera
        delegate = self
        handleVC?.showDetailViewController(self, sender: nil)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = (info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage)
        let w = UIScreen.main.bounds.width
        let h = w * imagescaleHW
        let x: CGFloat = 0
        let y: CGFloat = (UIScreen.main.bounds.height - h) * 0.5
        let rect = CGRect(x: x, y: y, width: w, height: h)
        let vc = YYImageClipViewController(image: image, cropFrame: rect, limitScaleRatio: 3, isCycle: isCycle)
        vc?.delegate = self
        dismiss(animated: true) {
            guard let vc = vc else {
                log("vc为nil")
                return
            }
            self.handleVC?.present(vc, animated: true)
        }
    }
    
    func imageCropperDidCancel(_ clipViewController: YYImageClipViewController!) {
        clipViewController.dismiss(animated: true)
    }
    
    func imageCropper(_ clipViewController: YYImageClipViewController!, didFinished editedImage: UIImage!) {
        if let block = callBack {
            block(editedImage)
        }
        clipViewController.dismiss(animated: true)
    }
}

