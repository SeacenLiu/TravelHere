//
//  Date+Ex.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/6/23.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation

/// 日期格式化器
private let dateFormatter = DateFormatter()
/// 当前日历对象
private let calendar = Calendar.current

extension Date {
    
    static func dateDescription(with time: Int) -> String {
        return self.th_date(time: time).th_dateDescription
    }
    
    static func th_date(time: Int) -> Date {
        let value = TimeInterval(time) / 1000.0
        return Date(timeIntervalSince1970: value)
    }
    
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
     */
    var th_dateDescription: String {
        // 1. 判断日期是否是今天
        if calendar.isDateInToday(self) {
            let delta = -Int(self.timeIntervalSinceNow)
            if delta < 60 {
                return "刚刚"
            }
            if delta < 3600 {
                return "\(delta / 60) 分钟前"
            }
            return "\(delta / 3600) 小时前"
        }
        // 2. 其他天
        var fmt = " HH:mm"
        if calendar.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        } else {
            fmt = "MM-dd" + fmt
            let year = calendar.component(.year, from: self)
            let thisYear = calendar.component(.year, from: Date())
            if year != thisYear {
                fmt = "yyyy-" + fmt
            }
        }
        // 设置日期格式字符串
        dateFormatter.dateFormat = fmt
        return dateFormatter.string(from: self)
    }
}
