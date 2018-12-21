//
//  TableViewModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/17.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TableViewModelType {
    associatedtype Element: Decodable
    
    var data: Driver<[Element]> { get }
    var refreshStatus: Driver<RefreshStatus> { get }
    var hasContent: Driver<Bool> { get }
}
