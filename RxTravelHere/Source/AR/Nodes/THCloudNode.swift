//
//  THCloudNode.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/7/25.
//  Copyright © 2018年 成. All rights reserved.
//

import SceneKit

struct CloudNodeModel {
    let record: Record.Model
    let comment: Comment.Detail
    
    static var empty: CloudNodeModel {
        return CloudNodeModel(record: .empty, comment: .empty)
    }
}

class THCloudNode: THShowNode {
    
    let commentDetail: Comment.Detail
    
    init(with vm: CloudNodeModel) {
        self.commentDetail = vm.comment
        super.init(with: vm.record)
        setupUI()
    }
    
    init(with model: Record.Model, commentDetail: Comment.Detail) {
        self.commentDetail = commentDetail
        super.init(with: model)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let box: SCNBox = SCNBox(width: 0.36, height: 0.21, length: 0.1, chamferRadius: 0)
        let scenceName = "cloud.scn"
        
        let scence = SCNScene(named: scenceName)
        guard let node = scence?.rootNode else {
            fatalError("没有rootNode")
        }
        self.addChildNode(node)
        
        // 添加文字
        var string = ""
        var contentString = ""
        if let reply = commentDetail.reply {
            contentString = reply
            string = "新回复"
        }
        else {
            contentString = commentDetail.text
            string = "新评论"
        }
        
        let textNode = SCTextNode(string: string, color: .red)
        textNode.position = SCNVector3(0, 0.025, box.length*0.5)
        addChildNode(textNode)
        
        if contentString.count > 5 {
            contentString = String(contentString.prefix(5))
            contentString += "..."
        }
        let contentNode = SCTextNode(string: contentString, color: .black)
        contentNode.position = SCNVector3(0, -0.025, box.length*0.5)
        addChildNode(contentNode)
        
        
        box.materials.first?.diffuse.contents = UIColor.clear
        geometry = box
        
        // 添加约束
        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = .Y
        constraints = [constraint]
    }
}

extension THCloudNode {
    public func showAnimate() {
        let scaleOut = SCNAction.scale(by: 0.5, duration: 0.25)
        let fadeOut = SCNAction.fadeOut(duration: 0.25)
        let scaleIn = SCNAction.scale(by: 2, duration: 0.5)
        let fadeIn = SCNAction.fadeIn(duration: 0.5)
        let group1 = SCNAction.group([scaleOut, fadeOut])
        let group2 = SCNAction.group([scaleIn, fadeIn])
        
        let aniamte = SCNAction.sequence([group1, group2])
        
        runAction(aniamte)
    }
}
