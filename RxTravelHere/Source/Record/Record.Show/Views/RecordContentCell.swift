//
//  RecordContentCell.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/17.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit
import Kingfisher

protocol RecordContentRepresentable {
    var userNickname: String { get }
    var time: String { get }
    var content: String { get }
    var locationStr: String { get }
    var avatarResource: Resource? { get }
}

class RecordContentCell: UITableViewCell {
    
    static let cellIdentifier = "RecordContentCellId"
    
    static func registered(by tableView: UITableView) {
        tableView.register(UINib(nibName: "RecordContentCell", bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
    }
    
    @IBOutlet weak var avatorIv: UIImageView!
    @IBOutlet weak var nickLb: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var textLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    
    public func config(with vm: RecordContentRepresentable) {
        nickLb.text = vm.userNickname
        timeLb.text = vm.time
        textLb.text = vm.content
        locationLb.text = vm.locationStr
        avatorIv.kf.setImage(
            with: vm.avatarResource,
            placeholder: UIImage(named: "unlogin_avator")!)
    }
    
}
