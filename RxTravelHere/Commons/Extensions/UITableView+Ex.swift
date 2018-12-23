//
//  UITableView+Ex.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/23.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

extension UITableView {
    convenience init(style: Style, config: (_ tv: UITableView) -> ()) {
        self.init(frame: .zero, style: style)
        self.showsVerticalScrollIndicator = false
        self.contentInsetAdjustmentBehavior = .never
        self.separatorStyle = .none
        self.backgroundColor = .white
        config(self)
    }
}
