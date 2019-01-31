//
//  InteractionCell.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/6/14.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

protocol InteractionRepresentable {
    var commentContent: String { get }
    var userNickname: String {get}
    var messageAddress: String {get}
    var commentReplyContent: String? {get}
    var isHideRedPoint: Bool { get }
    var status: Int { get }
}

class InteractionCell: UITableViewCell {
    
    static let cellIdentifier = "InteractionCellId"
    
    @IBOutlet weak var redpoint: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var contentLb: UILabel!
    @IBOutlet weak var replyLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    @IBOutlet weak var replyBottom: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    
    public func setHiddenRedPoint(value: Bool) {
        redpoint.isHidden = value
    }
    
    func config(with vm: InteractionRepresentable) {
        contentLb.text = vm.commentContent
        var titleText: String
        var replyName: String
        switch vm.status {
        case 0:
            titleText = "我评论了\(vm.userNickname)的留言"
            replyName = vm.userNickname
        default:
            titleText = "\(vm.userNickname)评论了我的留言"
            replyName = "我"
        }
        titleLb.text = titleText
        locationLb.text = vm.messageAddress
        if let reply = vm.commentReplyContent {
            let range = NSRange(location: 0, length: replyName.count+1)
            let string = replyName + "：" + reply
            let attribute = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
            let attrString = NSMutableAttributedString(string: string, attributes: attribute)
            attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1), range: range)
            replyLb.attributedText = attrString
            replyBottom.constant = 12
            bgView.isHidden = false
        } else {
            replyLb.text = ""
            replyBottom.constant = 0
            bgView.isHidden = true
        }
        setHiddenRedPoint(value: vm.isHideRedPoint)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        
        redpoint.layer.cornerRadius = 5
        redpoint.layer.masksToBounds = true
        redpoint.image = UIImage.createImage(color: .red, rect: CGRect(x: 0, y: 0, width: 10, height: 10))
    }
}
