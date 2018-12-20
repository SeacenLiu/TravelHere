//
//  MainNavigationController.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/5.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = true
        
        // 设置右滑返回手势的代理为自身
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    deinit {
        log("MainNavigationController byebye.")
    }
}

extension MainNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if viewControllers.count < 2 || visibleViewController == viewControllers.first {
                return false
            }
        }
        return true
    }
}
