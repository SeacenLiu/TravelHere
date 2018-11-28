//
//  log.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/28.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

func log<T>( _ message: @autoclosure () -> T,
                file: String = #file,
                method: String = #function,
                line: Int = #line) {
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message())")
    #endif
}
