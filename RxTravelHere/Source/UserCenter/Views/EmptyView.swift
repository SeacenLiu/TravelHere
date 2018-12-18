//
//  EmptyView.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/6/23.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit
import SnapKit

class EmptyView: UIView {
    
    let showText: String
    
    init(text: String) {
        self.showText = text
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var textLb: UILabel = {
        let lb = UILabel()
        lb.text = showText
        lb.textColor = .darkGray
        lb.font = UIFont.systemFont(ofSize: 18)
        return lb
    }()
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(textLb)
        textLb.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

}
