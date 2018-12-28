//
//  ShapeTypeCell.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/28.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

protocol ShapeTypeCellRepresentable {
    var contentImage: UIImage { get }
    var isSelect: Bool { get }
}

class ShapeTypeCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ShapeTypeCellId"
    
    static func registered(by cv: UICollectionView) {
        cv.register(UINib(nibName: "ShapeTypeCell", bundle: nil), forCellWithReuseIdentifier: self.reuseIdentifier)
    }
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var selectedIv: UIImageView!
    
    public func config(with vm: ShapeTypeCellRepresentable) {
        contentImageView.image = vm.contentImage
        selectedIv.isHidden = !vm.isSelect
    }
}
