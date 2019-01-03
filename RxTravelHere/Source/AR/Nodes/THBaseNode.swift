//
//  THBaseNode.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/27.
//  Copyright © 2018年 成. All rights reserved.
//

import SceneKit

class THBaseNode: THShowNode {
    override init(with model: Record.Model) {
        super.init(with: model)
        setupUI()
        self.position = PositionManager.shared
            .computePosition(with: self.model.detail.coordinate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        var scenceName = ""
        var textColor: UIColor
        var box: SCNBox
        switch model.detail.type {
        case .heart:
            scenceName = "heart.scn"
            textColor = .white
            box = SCNBox(width: 0.520, height: 0.5, length: 0.2, chamferRadius: 0)
        case .note:
            scenceName = "note.scn"
            textColor = .black
            box = SCNBox(width: 0.485, height: 0.476, length: 0.202, chamferRadius: 0)
        case .blackboard:
            scenceName = "blackboard.scn"
            textColor = .white
            box = SCNBox(width: 0.608, height: 0.511, length: 0.03, chamferRadius: 0)
        }
        box.firstMaterial?.writesToDepthBuffer = false
        let scence = SCNScene(named: scenceName)
        guard let node = scence?.rootNode else {
            fatalError("没有rootNode")
        }
        self.addChildNode(node)
        
        // 添加文字
        var string = model.detail.text
        if string.count > 5 {
            string = String(string.prefix(5))
            string += "..."
        }
        let textNode = SCTextNode(string: string, color: textColor)
        textNode.position = SCNVector3(0, 0, box.length*0.5)
        addChildNode(textNode)
        
        box.materials.first?.diffuse.contents = UIColor.clear
        geometry = box
        
        // 添加约束
        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = .Y
        constraints = [constraint]
    }
}
