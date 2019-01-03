//
//  SVProgressHUD+Ex.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/30.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation
import SVProgressHUD

private let kSVDefaultDuration: TimeInterval = 1.5

extension SVProgressHUD {
    class func showTip(status: String, duration: TimeInterval = kSVDefaultDuration, completion: (()->())? = nil) {
        SVProgressHUD.showInfo(withStatus: status)
        SVProgressHUD.dismiss(withDelay: kSVDefaultDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
    
    class func showSuccess(status: String, duration: TimeInterval = kSVDefaultDuration, completion: (()->())? = nil) {
        SVProgressHUD.showSuccess(withStatus: status)
        SVProgressHUD.dismiss(withDelay: kSVDefaultDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
    
    class func showError(status: String, duration: TimeInterval = kSVDefaultDuration, completion: (()->())? = nil) {
        SVProgressHUD.showError(withStatus: status)
        SVProgressHUD.dismiss(withDelay: kSVDefaultDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
}

extension UIViewController {
    func showHUD() {
        SVProgressHUD.show()
    }
    
    func showHUD(error: Error, completion: (()->())? = nil) {
        SVProgressHUD.showError(status: error.localizedDescription, completion: completion)
    }
    
    func showHUD(errorText: String, completion: (()->())? = nil) {
        SVProgressHUD.showError(status: errorText, completion: completion)
    }
    
    func showHUD(successText: String, completion: (()->())? = nil) {
        SVProgressHUD.showSuccess(status: successText, completion: completion)
    }
    
    func showHUD(infoText: String, completion: (()->())? = nil) {
        SVProgressHUD.showTip(status: infoText, completion: completion)
    }
}
