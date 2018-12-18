//
//  RedPointView.swift
//  RabbitMQDemo
//
//  Created by SeacenLiu on 2018/7/23.
//  Copyright © 2018年 SeacenLiu. All rights reserved.
//

import UIKit

let redPointW: CGFloat = 20

class RedPointView: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    init(count: Int = 0) {
        super.init(frame: CGRect(x: 0, y: 0, width: redPointW, height: redPointW))
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var count: Int = 0 {
        didSet {
            text = "\(count)"
            isHidden = count == 0
        }
    }
    
    private func setupUI() {
        backgroundColor = UIColor.red
        
        layer.cornerRadius = redPointW * 0.5
        layer.masksToBounds = true
        
        font = UIFont.boldSystemFont(ofSize: 11.0)
        textColor = .white
        textAlignment = .center
        text = "88"
    }

}
