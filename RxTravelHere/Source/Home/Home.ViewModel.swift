//
//  Home.ViewModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/5.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

extension Home {
    /// 地图显示结果返回
    struct MapShowResult {
        let olds: [Annotation]?
        let news: [Annotation]?
        
        static var defaultResult: MapShowResult {
            return MapShowResult(olds: nil, news: nil)
        }
    }
    
    final class ViewModel {
        
        // Output
        private var _showRecord: Driver<MapShowResult>?
        var showRecord: Driver<MapShowResult> {
            return _showRecord!
        }
        
        // Input
        let avatar: Driver<UIImage>
        
        private let _disposeBag = DisposeBag()
        
        // 保存状态用
        var curRecordModels: [Record.Model]?
        var curAnnotations: [Annotation]?
        
        init(input: (locations: Observable<CLLocationCoordinate2D>, refreshTap: Signal<()>)) {
            let provider = MoyaProvider<Record.NetworkTarget>()
            
            input.locations
                .bind(to: PositionManager.shared.rx.location)
                .disposed(by: _disposeBag)
            
            avatar = Account.Manager.shared.avatar
                .asDriver(onErrorJustReturn: UIImage(named: "unlogin_avator")!)
            
            let firstLocation = input.locations.take(1)
            
            let tapRefresh = input.refreshTap
                .withLatestFrom(input.locations
                    .asDriver(onErrorJustReturn: CLLocationCoordinate2D()))
                .asObservable()
            
            let concat = Observable.concat(firstLocation, tapRefresh)
            
            _showRecord = concat
                .asDriver(onErrorJustReturn: CLLocationCoordinate2D())
                .flatMapLatest {  location in
                    return provider.rx
                        .request(Record.NetworkTarget.arroundRecord(
                            longitude: location.longitude,
                            latitude: location.latitude,
                            distance: 150,
                            page: 1,
                            count: 20))
                        .map(NetworkResponse<[Record.Model]>.self)
                        .map{ response -> [Annotation] in
                            defer { self.curRecordModels = response.data  }
                            return response.data.map{
                                Annotation(
                                    type: $0.detail.type,
                                    latitude: $0.detail.latitude,
                                    longitude: $0.detail.longitude
                                )
                            }
                        }
                        .map({ (annotations) -> MapShowResult in
                            defer { self.curAnnotations = annotations}
                            return MapShowResult(
                                olds: self.curAnnotations,
                                news: annotations
                            )
                        })
                        .asDriver(onErrorJustReturn: .defaultResult)
            }
        }
    }
}
