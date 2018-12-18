//
//  InteractionCell.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/6/14.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class InteractionCell: UITableViewCell {
    
    public func setHiddenRedPoint(value: Bool) {
        redpoint.isHidden = value
    }
    
    var model: UserCenter.Interaction.Model? {
        didSet {
            guard let model = model else { return }
            contentLb.text = model.commentContent
            var titleText: String
            var replyName: String
            switch model.status {
            case 0:
                titleText = "我评论了\(model.userNickname)的留言"
                replyName = model.userNickname
            default:
                titleText = "\(model.userNickname)评论了我的留言"
                replyName = "我"
            }
            titleLb.text = titleText
            locationLb.text = model.messageAddress
            if let reply = model.commentReplyContent {
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
            
            // TODO: - 设置小红点
//            setHiddenRedPoint(value: THRedPointManager.shared.isUnreadComment(cid: model.commentId))
        }
    }
    
    @IBOutlet weak var redpoint: UIImageView!
    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var contentLb: UILabel!
    
    @IBOutlet weak var replyLb: UILabel!
    
    @IBOutlet weak var locationLb: UILabel!
    
    @IBOutlet weak var replyBottom: NSLayoutConstraint!
    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        
        redpoint.layer.cornerRadius = 5
        redpoint.layer.masksToBounds = true
        redpoint.image = UIImage.createImage(color: .red, rect: CGRect(x: 0, y: 0, width: 10, height: 10))
    }
}
