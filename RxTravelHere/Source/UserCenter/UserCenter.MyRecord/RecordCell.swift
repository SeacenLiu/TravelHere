//
//  RecordCell.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/17.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {
    
    static let cellIdentifier = "RecordCellId"
    
    public var model: Record.Detail? {
        didSet {
            guard let model = model else { return }
            titleLb.text = model.text
            locationLb.text = model.locationStr
        }
    }
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    @IBOutlet weak var lineIv: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineIv.image = UIImage.createImage(color: #colorLiteral(red: 0.431372549, green: 0.4352941176, blue: 0.4352941176, alpha: 1), rect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-48, height: 0.333))
    }
    
}
