//
//  RecordCell.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/17.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

protocol MyRecordRepresentable {
    var text: String { get }
    var locationStr: String {get}
}

class RecordCell: UITableViewCell {
    
    static let cellIdentifier = "RecordCellId"
    
    func config(with vm: MyRecordRepresentable) {
        titleLb.text = vm.text
        locationLb.text = vm.locationStr
    }
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
}
