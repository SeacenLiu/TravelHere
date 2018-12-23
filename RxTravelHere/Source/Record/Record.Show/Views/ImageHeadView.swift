//
//  ImageHeadView.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/19.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class ImageHeadView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "headImageViewId"
    
    static let imageScale: CGFloat = 195.0 / 312.0
    
    static func headerHeight(with scrollView: UIScrollView) -> CGFloat {
        return self.imageScale * scrollView.bounds.width
    }
    
    static func registered(by tableView: UITableView) {
        tableView.register(ImageHeadView.self, forHeaderFooterViewReuseIdentifier: self.reuseIdentifier)
    }
    
    private let limitOffsetY: CGFloat = -150
    
    static func change(with scrollView: UIScrollView, section: Int) {
        guard let v = scrollView as? UITableView,
            let head = v.headerView(forSection: section) as? ImageHeadView else {
                fatalError("不存在此 header View")
        }
        head.change(with: scrollView)
    }
    
    func change(with scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let imageHeight = ImageHeadView.headerHeight(with: scrollView)
        // 上拉不处理
        if offsetY >= 0 {
            return
        }
        // 限制下拉距离
        if offsetY < limitOffsetY {
            scrollView.contentOffset = CGPoint(x: 0, y: limitOffsetY)
        }
        // 改变图片大小
        let newOffsetY = scrollView.contentOffset.y
        let newHeight = imageHeight - newOffsetY
        let newWidth = newHeight / ImageHeadView.imageScale
        let newX = (scrollView.bounds.width - newWidth) * 0.5
        let newY = newOffsetY
        imageView.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }
    
    static func load(with tableView: UITableView) -> ImageHeadView {
        var hv: ImageHeadView!
        if let v = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.reuseIdentifier) as? ImageHeadView {
            hv = v
        } else {
            hv = ImageHeadView(reuseIdentifier: self.reuseIdentifier)
        }
        hv.imageView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: ImageHeadView.headerHeight(with: tableView))
        return hv
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "test_head_img")
        return iv
    }()
    
}
