//
//  Threads.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation

func syncInMain<T>(_ todo: () throws -> T) rethrows -> T {
    if Thread.isMainThread { return try todo() }
    return try DispatchQueue.main.sync(execute: todo)
}

func nextRunLoopPeriod(_ todo: @escaping () -> ()) {
    assert(Thread.isMainThread)
    DispatchQueue.main.async(execute: todo)
}
