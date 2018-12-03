//
//  Account.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/28.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

extension Account {
    final class View: UINavigationController {
        init() {
//            super.init(rootViewController: PhoneLogin.View())
            super.init(rootViewController: Edit.View())
        }
        
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            isNavigationBarHidden = true
            
            // 设置右滑返回手势的代理为自身
            if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
                interactivePopGestureRecognizer?.delegate = self
            }
        }
    }
}

extension Account.View: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if viewControllers.count < 2 || visibleViewController == viewControllers.first {
                return false
            }
        }
        return true
    }
}
