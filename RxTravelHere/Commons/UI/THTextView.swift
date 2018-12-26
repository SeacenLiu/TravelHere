//
//  THTextView.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/18.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class THTextView: UITextView {
    
    /// 占位字符
    public var placeHolder: String = "请输入你想再这里留下的话..." {
        didSet {
            placeHoderLb.text = placeHolder
        }
    }
    
    /// 是否编辑
    public var isEdit: Bool = false {
        didSet {
            placeHoderLb.isHidden = isEdit
        }
    }
    
    /// 字体
    public var textFont: UIFont = UIFont(name: "PingFangSC-Regular", size: 18)! {
        didSet {
            font = textFont
            placeHoderLb.font = textFont
        }
    }

    /// 指定构造函数
    init() {
        super.init(frame: .zero, textContainer: nil)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    /// 占位Label
    private lazy var placeHoderLb: UILabel = {
        let lb = UILabel()
        lb.text = placeHolder
        lb.font = textFont
        lb.textColor = .lightGray
        lb.sizeToFit()
        return lb
    }()
    
    private func setupUI() {
        delegate = self
        
        alwaysBounceVertical = true
        font = textFont
        
        addSubview(placeHoderLb)
        placeHoderLb.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(8)
        }
    }
    
}

extension THTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        isEdit = textView.text.count != 0
    }
}

