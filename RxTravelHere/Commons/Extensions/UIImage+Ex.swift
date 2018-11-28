//
//  UIImage+Ex.swift
//  travel
//
//  Created by 成 on 2017/11/7.
//  Copyright © 2017年 成. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 裁剪成圆形图片
    ///
    /// - Parameter diameter: 直径
    /// - Returns: UIImage?
    func transformImage(diameter: Double) -> UIImage? {
        var newImage: UIImage?
        var newSize = CGSize(width: diameter, height: diameter)
        newSize.width *= UIScreen.main.scale
        newSize.height *= UIScreen.main.scale
        
        UIGraphicsBeginImageContext(newSize)
        
        let context = UIGraphicsGetCurrentContext();
        context?.addEllipse(in: CGRect(origin: CGPoint.zero, size: newSize))
        context?.clip()
        
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            if let newCgImage = image.cgImage {
                newImage = UIImage(cgImage: newCgImage, scale: UIScreen.main.scale, orientation: .up)
            }
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// 按比例缩小图片
    ///
    /// - Parameter width: 宽度
    /// - Returns: UIImage
    func scaleToWidth(width: CGFloat) -> UIImage? {
        if size.width < width {
            return self
        }
        var newImage: UIImage?
        let height = size.height * width / size.width
        var newSize = CGSize(width: width, height: height)
        newSize.width *= UIScreen.main.scale
        newSize.height *= UIScreen.main.scale
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(origin: .zero, size: newSize))
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            if let newCgImage = image.cgImage {
                newImage = UIImage(cgImage: newCgImage, scale: UIScreen.main.scale, orientation: .up)
            }
        }
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// (只转成JPG)UIImage转Data
    ///
    /// - Returns: Data
    var imageJpgData: Data? {
        var data = jpegData(compressionQuality: 1.0)
        guard let count = data?.count else {
            return nil
        }
        if count > 1024*1024 { //1M以及以上
            data = jpegData(compressionQuality: 0.1)
        } else if count > 512*1024 { //0.5M-1M
            data = jpegData(compressionQuality: 0.5)
        } else if count > 200*1024 { //0.25M-0.5M
            data = jpegData(compressionQuality: 0.9)
        }
        return data
    }
    
    /// 创建纯色图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - rect: 大小
    /// - Returns: UIImage
    class func createImage(color: UIColor, rect: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)) -> UIImage? {
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }

    
}
