//
//  AppDelegate.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/28.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import Moya

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AMapServices.shared().apiKey = "6a23acb4df3d6f2fbbe95b422b4523ec"
        AMapServices.shared().enableHTTPS = true
        rxPrepare()
        autoLogin()
        loadWindow()
        
        return true
    }
    
    private func loadWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = Account.View()
        window?.rootViewController = MainNavigationControler(rootViewController: Map.Show.View())
        window?.makeKeyAndVisible()
    }
    
    private func autoLogin() {
        Account.Manager.shared.autoLogin()
    }
    
    private func rxPrepare() {
        RxImagePickerDelegateProxy.register { RxImagePickerDelegateProxy(imagePicker: $0) }
    }

}

