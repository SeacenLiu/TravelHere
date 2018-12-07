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
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: account, requiringSecureCoding: false) else { fatalError("存档失败") }
            UserDefaults.standard.set(data, forKey: accountKey)
        }
    }
    
    class func removeUserInfo() {
        UserDefaults.standard.removeObject(forKey: accountKey)
    }
}
