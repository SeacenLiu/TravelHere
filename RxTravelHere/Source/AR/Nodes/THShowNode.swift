//
//  THShowNode.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/7/25.
//  Copyright © 2018年 成. All rights reserved.
//

import SceneKit

class THShowNode: SCNNode {
    let model: Record.Model
    
    init(with model: Record.Model) {
        self.model = model
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
