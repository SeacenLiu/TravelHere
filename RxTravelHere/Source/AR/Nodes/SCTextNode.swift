//
//  SCTextNode.swift
//  demo1
//
//  Created by SeacenLiu on 2018/6/19.
//  Copyright © 2018年 成. All rights reserved.
//

import SceneKit

class SCTextNode: SCNNode {
    
    init(string: String, color: UIColor) {
        super.init()
        let text3D = SCNText(string: string, extrusionDepth: 0.001)
        text3D.font = UIFont(name: "Helvetica", size: 1)
        text3D.materials.first?.diffuse.contents = color
        let textNode = SCNNode(geometry: text3D)
        // 缩放 node
        textNode.scale = SCNVector3(0.04, 0.04, 1)
        // 将TextNode的中心移到中间
        recenterText(withNode: textNode)
        addChildNode(textNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重置中心
    private func recenterText(withNode node: SCNNode) {
        guard let text = node.geometry as? SCNText else {
            fatalError("这个结点的几何图形不是SCNText")
        }
        let boundingBox = text.boundingBox
        let textH = (boundingBox.max.y - boundingBox.min.y) * node.scale.y
        let textW = (boundingBox.max.x - boundingBox.min.x) * node.scale.x
        let position = SCNVector3(-textW/2.0, -textH/2.0, 0)
        node.position = position
    }
    
}
