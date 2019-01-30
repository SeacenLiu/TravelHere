//
//  UserDefaults+Ex.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/5.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

private let accountKey = "Account"
extension UserDefaults {
    class var account: Account.Model? {
        get {
            guard let data = UserDefaults.standard.data(forKey: accountKey) else { return nil }
            guard let account = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Account.Model else { return nil }
            return account
        }
        set {
            guard let account = newValue else { UserDefaults.standard.removeObject(forKey: accountKey); return }
//            guard c else { fatalError("存档失败") }
            do {
                if #available(iOS 11.0, *) {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: account, requiringSecureCoding: false)
                    UserDefaults.standard.set(data, forKey: accountKey)
                } else {
                    // Fallback on earlier versions
                    let data = NSKeyedArchiver.archivedData(withRootObject: account)
                    UserDefaults.standard.set(data, forKey: accountKey)
                }
            } catch {
                log(error)
            }
        }
    }
    
    class func removeUserInfo() {
        UserDefaults.standard.removeObject(forKey: accountKey)
    }
}
