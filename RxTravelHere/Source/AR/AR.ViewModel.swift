//
//  AR.ViewModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import SceneKit
import RxSwift
import RxCocoa
import Moya

extension AR {
    internal class ViewModel {
        var records = [Record.Model]()
        
        let arroundNodes: Driver<[THShowNode]>
        let newClound: Driver<CloudNodeModel>
        let addNodeSubject = PublishSubject<Record.Model>()
        
        init(with records: [Record.Model]?) {
            if let ms = records {
                self.records = ms
            }
            
            let provider = MoyaProvider<Record.NetworkTarget>()
            arroundNodes = Driver.of(self.records).map{$0.map{THBaseNode(with: $0)}}
            newClound = THRedPointManager.shared.newComment.asDriver(onErrorJustReturn: .empty)
                .flatMapLatest { comment in
                    provider.rx
                        .request(.oneRecord(id: comment.recordId))
                        .map(NetworkResponse<Record.Model>.self)
                        .map { CloudNodeModel(record: $0.data, comment: comment) }
                        .asDriver(onErrorJustReturn: .empty)
            }
        }
        
        public func getRecordViewModel(with node: THShowNode) -> Record.Show.ViewModel {
            let m = node.model
            let vm = Record.Show.ViewModel(with: m)
            return vm
        }
        
        public func changeRecordLocation(node: THShowNode, aimPosition: SCNVector3) {
            let newLocation = PositionManager.shared.computeCoordinate2D(position: aimPosition)
            var model = node.model
            model.changeCoordinate(with: newLocation)
            // TODO: - 将修改后的模型告诉首页
            addNodeSubject.onNext(model)
            // 更新后台留言
            let provider = MoyaProvider<Record.NetworkTarget>()
            _ = provider.rx.request(
                .modifyRecord(messageId: model.id,
                              messageLongitude:
                    newLocation.longitude, messageLatitude: newLocation.latitude))
                .subscribe(onSuccess: { (_) in
                    log("成功修改")
                }) { (err) in
                    log("修改错误: \(err)")
            }
        }
    }
}
