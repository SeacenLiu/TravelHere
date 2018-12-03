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
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = Account.View()
        window?.makeKeyAndVisible()
        
//        testImageUpload()
        
        return true
    }
    
    func testImageUpload() {
        // http://119.23.47.182:8088/group1/M00/00/00/rBMAA1wEpCqAdr90AAKG3xrnPlc400.jpg
        let target = FileNetworkTarget(UIImage(named: "test_head_img")!.imageJpgData!)
        MoyaProvider<FileNetworkTarget>().request(target) { (result) in
            switch result {
            case let .success(response):
                let imageInfo = try! JSONDecoder().decode(NetworkResponse<ImageInfo>.self, from: response.data)
                log(imageInfo)
                log(imageInfo.data.path)
                break
            case let .failure(err):
                fatalError(err.localizedDescription)
                break
            }
        }
    }

}

