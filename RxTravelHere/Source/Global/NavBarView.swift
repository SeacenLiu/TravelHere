//
//  NavBarView.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/27.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class NavBarView: UIView {
    
    var navigationController: UINavigationController?
    
    var Height: CGFloat {
        return UIDevice.statusBarH + 44
    }
    
    public var barColor: UIColor = #colorLiteral(red: 0, green: 0.7176470588, blue: 0.8039215686, alpha: 1) {
        didSet {
            backgroundColor = barColor.withAlphaComponent(barAlpha)
        }
    }
    
    public var barAlpha: CGFloat = 1 {
        didSet {
            backgroundColor = barColor.withAlphaComponent(barAlpha)
        }
    }
    
    public var backTitle: String = "" {
        didSet {
            backBtn.setTitle(backTitle, for: .normal)
        }
    }
    
    public func change(with scrollView: UIScrollView, headerH: CGFloat) {
        let offsetY = scrollView.contentOffset.y
        let aim = headerH - 44.0 - UIDevice.statusBarH
        if offsetY >= aim && !self.isHidden {
            self.barAlpha = 1
        } else {
            let alpha = offsetY / aim
            self.barAlpha = alpha
        }
    }

    @IBOutlet weak var backBtn: TouchBigBtn!
    @IBAction func backBtnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    class func naviBarView(with nav: UINavigationController?, config: ((NavBarView) -> ())? = nil) -> NavBarView {
        let v = self.nibView() as! NavBarView
        v.navigationController = nav
        config?(v)
        return v
    }

}
