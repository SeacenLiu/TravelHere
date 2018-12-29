//
//  LocationSearcher+Rx.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchResult {
    let location: CLLocationCoordinate2D
    let address: String
    
    var longitude: Double { return location.longitude }
    var latitude: Double { return location.latitude }
    
    static var failure: SearchResult {
        return SearchResult(location: .init(), address: "位置错误")
    }
}

extension Reactive where Base: LocationSearcher {
    func search() -> Single<SearchResult> {
        // TODO: - [unowned self] ???
        return Single<SearchResult>.create(subscribe: { single -> Disposable in
            self.base.searchLocationName(success: { (locationStr) in
                single(.success(SearchResult(location: self.base.location, address: locationStr)))
            }, failure: { (err) in
                single(.error(err))
            })
            return  Disposables.create()
        })
    }

}
