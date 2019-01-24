//
//  PositionManager.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import SceneKit

class PositionManager {
    static let shared = PositionManager()
    
    private(set) var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    public func changeCurrent(coordinate: CLLocationCoordinate2D) {
        currentLocation = coordinate
        // FIXME: - 写死定位
//        currentLocation = CLLocationCoordinate2D(latitude: 21.15209852430555, longitude: 110.3004633246528)
    }
    
    private init() {}
    
    let prelatitudeMeter: Double = 111000
    
    /// 经纬度计算平面坐标
    public func computePosition(with location: CLLocationCoordinate2D) -> SCNVector3 {
        var x = currentLocation.longitude - location.longitude
        var z = currentLocation.latitude - location.latitude
        x *= prelatitudeMeter*cos(location.latitude)
        z *= prelatitudeMeter
        let positoin = SCNVector3(x, 0, z)
        return positoin
    }
    
    /// 平面坐标计算经纬度
    public func computeCoordinate2D(position: SCNVector3) -> CLLocationCoordinate2D {
        let z = Double(position.z)
        let latitude = currentLocation.latitude - (z / prelatitudeMeter)
        let x = Double(position.x)
        let longitude = currentLocation.longitude - x / prelatitudeMeter / cos(latitude)
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
