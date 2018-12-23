//
//  CommentCell.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/17.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation
import Kingfisher

protocol CommentRepresentable {
    var userNickname: String { get }
    var time: String { get }
    var text: String { get }
    var avatarResource: Resource? { get }
    var reply: String? { get }
}

class CommentCell: UITableViewCell {
    
    static let cellIdentifier = "CommentCellId"
    
    static let margin: CGFloat = 12
    
    static func registered(by tableView: UITableView) {
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
    }
    
    @IBOutlet weak var pillarH: NSLayoutConstraint!
    @IBOutlet weak var buildHostH: NSLayoutConstraint!
    @IBOutlet weak var buildAndReplyMargin: NSLayoutConstraint!
    @IBOutlet weak var replyBottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var avatorIv: UIImageView!
    @IBOutlet weak var nickLb: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var textLb: UILabel!
    @IBOutlet weak var replyLb: UILabel!
    @IBOutlet weak var pillarIv: UIImageView!
    
    public func config(with vm: CommentRepresentable) {
        nickLb.text = vm.userNickname
        timeLb.text = vm.time
        textLb.text = vm.text
        avatorIv.kf.setImage(
            with: vm.avatarResource,
            placeholder: UIImage(named: "unlogin_avator")!)
        
        // 回复处理
        if let reply = vm.reply {
            replyLb.text = reply
            pillarH.constant = CommentCell.margin
            buildHostH.constant = CommentCell.margin
            buildAndReplyMargin.constant = CommentCell.margin
            buildAndReplyMargin.constant = CommentCell.margin
            replyBottomMargin.constant = CommentCell.margin
        } else {
            replyLb.text = ""
            pillarH.constant = 0
            buildHostH.constant = 0
            buildAndReplyMargin.constant = 0
            buildAndReplyMargin.constant = 0
            replyBottomMargin.constant = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pillarIv.image = UIImage.createImage(color: #colorLiteral(red: 0.3215686275, green: 0.5215686275, blue: 0.6, alpha: 1), rect: CGRect(x: 0, y: 0, width: 4, height: 12))
    }
}
