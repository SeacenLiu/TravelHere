//
//  EditView.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/28.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

internal class EditView: UIView {
    @IBOutlet weak var closeBtn: TouchBigBtn!
    @IBOutlet weak var publishBtn: TouchBigBtn!
    @IBOutlet weak var textView: THTextView!
    @IBOutlet weak var addImgBtn: UIButton!
    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var templateView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ShapeTypeCell.registered(by: templateView)
    }
}
