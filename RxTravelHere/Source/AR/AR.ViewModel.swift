//
//  AR.ViewModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import SceneKit
import RxSwift
import RxCocoa

extension AR {
    internal class ViewModel {
        var records = [Record.Model]()
        
        let nodes: Driver<[THShowNode]>
        
        init(with records: [Record.Model]?) {
            if let ms = records {
                self.records = ms
            }
            
            nodes = Driver.of(self.records).map{$0.map{THBaseNode(with: $0)}}
        }
        
        public func getRecordViewModel(with node: THShowNode) -> Record.Show.ViewModel {
            let m = node.model
            let vm = Record.Show.ViewModel(with: m)
            return vm
        }
    }
}
