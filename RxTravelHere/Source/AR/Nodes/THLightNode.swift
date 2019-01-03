//
//  THLightNode.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2019/1/2.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

import SceneKit

class THLightNode: SCNNode {
    override init() {
        super.init()
        light = SCNLight()
        light?.type = .omni // 全向光，即一个发光点
        position = SCNVector3(0, 2, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
