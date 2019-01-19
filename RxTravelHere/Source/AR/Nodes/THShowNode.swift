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
    
    func selectAction() {
        removeAction(forKey: "move")
        let scaleOut = SCNAction.scale(by: 2, duration: 0.2)
        let fadeOut = SCNAction.fadeOut(duration: 0.2)
        let group = SCNAction.group([scaleOut, fadeOut])
        runAction(group)
    }
    
    func unSelectAction() {
        let scaleIn = SCNAction.scale(by: 0.5, duration: 0.2)
        let fadeIn = SCNAction.fadeIn(duration: 0.2)
        let group = SCNAction.group([scaleIn, fadeIn])
        runAction(group)
    }
}
