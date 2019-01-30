//
//  ARWorldTrackingConfiguration+Ex.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2019/1/2.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

import ARKit

@available(iOS 11.0, *)
extension ARWorldTrackingConfiguration {
    convenience init(worldAlignment: WorldAlignment) {
        self.init()
        self.worldAlignment = worldAlignment
    }
}
