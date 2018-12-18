//
//  Account.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/28.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

extension Account {
    final class View: MainNavigationController {
        init() {
            super.init(rootViewController: PhoneLogin.View())
        }
        
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


