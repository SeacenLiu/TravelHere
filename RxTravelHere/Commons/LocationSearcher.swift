//
//  LocationSearcher.swift
//  高德地图使用
//
//  Created by 成 on 2017/11/3.
//  Copyright © 2017年 成. All rights reserved.
//

import Foundation

class LocationSearcher: NSObject {
    
    public var isActive: Bool = false
    private let poiTypes = "国家级景点|风景名胜|购物服务|餐饮服务|住宿服务|体育休闲服务|生活服务|学校"
    
    typealias AMapSearchCallBack = (_ name: String) -> ()
    typealias AMapSearchFailBack = (_ error: Error) -> ()
    private var callBack: AMapSearchCallBack?
    private var failBack: AMapSearchFailBack?
    
    let location: CLLocationCoordinate2D
    
    init(location: CLLocationCoordinate2D) {
        self.location = location
        super.init()
    }
    
    public func searchLocationName(success: @escaping AMapSearchCallBack, failure: @escaping AMapSearchFailBack) {
        searchPOIAround(page: 1, success: success, failure: failure)
    }
    
    deinit {
        log("LocationSearcher deinit")
    }
    
    // MARK: - lazy
    private lazy var search: AMapSearchAPI = {
        let s: AMapSearchAPI = AMapSearchAPI()
        s.delegate = self
        return s
    }()
}

// MARK: - 高德地图搜索定位
extension LocationSearcher: AMapSearchDelegate {
    
    /// 搜索周围POI
    private func searchPOIAround(page: Int, success: @escaping AMapSearchCallBack, failure: @escaping AMapSearchFailBack) {
        if isActive {
            return
        } else {
            isActive = true
        }
        self.callBack = success
        self.failBack = failure
        let request = AMapPOIAroundSearchRequest()
        let mp = AMapGeoPoint()
        mp.latitude = CGFloat(location.latitude)
        mp.longitude = CGFloat(location.longitude)
        request.location = mp
        request.types = poiTypes
        request.sortrule = 0
        request.page = page
        request.requireExtension = true
        search.aMapPOIAroundSearch(request)
    }
    
}

// MARK: - 处理操作
extension LocationSearcher {
    
    /// 搜索到POI的回调
    internal func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        defer { isActive = false }
        guard let callBack = callBack else { return }
        guard let poi = response.pois.first else {
            callBack("未知位置")
            return
        }
        callBack(poi.name)
    }
    
    /// 搜索失败的回调
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        failBack?(error)
        isActive = false
    }
    
}
