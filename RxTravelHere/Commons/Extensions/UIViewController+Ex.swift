//
//  UIViewController+Ex.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/21.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

enum Privilege: String {
    case location = "定位服务未开启,请进入系统设置>隐私>定位服务中打开开关,并允许\"到此一游\"使用定位服务"
    case album = "相册服务未开启,请进入系统设置>隐私>照片中打开开关,并允许\"到此一游\"使用相册"
    case camera = "相机服务未开启,请进入系统设置>隐私>相机中打开开关,并允许\"到此一游\"使用相机"
    case microphone = "麦克风服务未开启,请进入系统设置>隐私>麦克风中打开开关,并允许\"到此一游\"使用麦克风"
}

extension UIViewController {
    /// 下弹框 两个个按钮
    func showActionSheet(title: String?, message: String?, doneStr: String, handler: ((UIAlertAction) -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: doneStr, style: .destructive, handler: handler)
        alertVC.addAction(action)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancel)
        present(alertVC, animated: true)
    }
    
    /// 弹框 单个按钮
    func showAlert(title: String, message: String, doneStr: String, handler: ((UIAlertAction) -> Void)?, showCompletion: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: doneStr, style: .cancel, handler: handler)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: showCompletion)
    }
    
    /// 提示用户修改权限
    func tipChangePrivilege(privilege: Privilege) {
        let aleat = UIAlertController(title: "", message:privilege.rawValue, preferredStyle: .alert)
        let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
        }
        let callAction = UIAlertAction(title: "立即设置", style: .default) { (action) in
            if #available(iOS 10.0, *) {
                let url = NSURL.init(string: UIApplication.openSettingsURLString)
                if (UIApplication.shared.canOpenURL(url! as URL)) {
                    UIApplication.shared.open(url! as URL, options: [:])
                }
            } else {
                let url = URL(string: "prefs:root=LOCATION_SERVICES")!
                if (UIApplication.shared.canOpenURL(url)) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        aleat.addAction(tempAction)
        aleat.addAction(callAction)
        self.present(aleat, animated: true, completion: nil)
    }
    
    /// 获取当前显示的控制器
    class var currentController: UIViewController? {
        guard let window = UIApplication.shared.windows.first else {
            return nil
        }
        var tempView: UIView?
        for subview in window.subviews.reversed() {
            if subview.classForCoder.description() == "UILayoutContainerView" {
                tempView = subview
                break
            }
        }
        if tempView == nil {
            tempView = window.subviews.last
        }
        var nextResponder = tempView?.next
        var next: Bool {
            return !(nextResponder is UIViewController) || nextResponder is UINavigationController || nextResponder is UITabBarController
        }
        while next{
            tempView = tempView?.subviews.first
            if tempView == nil {
                return nil
            }
            nextResponder = tempView!.next
        }
        return nextResponder as? UIViewController
    }
}
