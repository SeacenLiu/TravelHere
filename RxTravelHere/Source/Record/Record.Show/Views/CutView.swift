//
//  CutView.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/22.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

class CutView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "CutViewId"
    
    static var headerHeight: CGFloat {
        return 18
    }
    
    static func registered(by tableView: UITableView) {
        tableView.register(UINib(nibName: "CutView", bundle: nil), forHeaderFooterViewReuseIdentifier: self.reuseIdentifier)
    }
    
    static func load(with tableView: UITableView) -> UITableViewHeaderFooterView {
        if let v = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.reuseIdentifier) {
            return v
        } else {
            return UITableViewHeaderFooterView(reuseIdentifier: self.reuseIdentifier)
        }
    }
}
