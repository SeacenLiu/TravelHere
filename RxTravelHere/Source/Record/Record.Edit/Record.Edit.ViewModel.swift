//
//  Record.Edit.ViewModel.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/27.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

extension Record.Edit {
    internal class ViewModel {
        typealias Content = (text: String, img: String, type: Int)
        
        let publishSuccess: Driver<Bool>
        let typeData: Driver<[ShapeTypeViewModel]>
        
        init(input: (text: Driver<String>, img: Driver<UIImage?>, type: Driver<Int>, doneTap: Signal<Void>)) {
            
            let provider = MoyaProvider<Record.NetworkTarget>()
            let imageProvider = MoyaProvider<FileNetworkTarget>()
            
            let content = Driver.combineLatest(input.text, input.img, input.type.startWith(0))
            
            typeData = input.type.map { ShapeTypeViewModel.dataProvide(selectIdx: $0) }
            publishSuccess = input.doneTap.withLatestFrom(content)
                .flatMapLatest { (text, img, type) ->  Driver<NetworkValid<Content>> in
                    guard let img = img else { return .of(.success(value: (text, "", type))) }
                    return imageProvider.rx
                        .request(FileNetworkTarget(img.imageJpgData!))
                        .map(NetworkResponse<ImageInfo>.self)
                        .map { .success(value: (text, $0.data.path, type)) }
                        .asDriver(onErrorJustReturn: .failure)
                }
                .flatMapLatest { result -> Driver<Bool> in
                    switch result {
                    case let .success(content):
                        return provider.rx
                            .request(.uploadRecord(
                                messageContent: content.text,
                                modelId: content.type,
                                messageLongitude: -1,
                                messageLatitude: -1,
                                messageImage: content.img,
                                messageAddress: "通过高德地图获取"))
                            .map(NetworkResponse<Account.User>.self)
                            .do(onSuccess: { _ in
                                // TODO: - 通知地图和AR模块增加留言
                            })
                            .map { $0.code == .success }
                            .asDriver(onErrorJustReturn: false)
                    case .failure:
                        return Driver<Bool>.just(false)
                    }
            }
        }
    }
    
    internal struct ShapeTypeViewModel: ShapeTypeCellRepresentable {
        let type: Record.Style
        let isSelect: Bool
        
        var contentImage: UIImage {
            return type.contentImage
        }
        
        init(type: Record.Style, selectIdx: Int) {
            self.type = type
            self.isSelect = type.rawValue == selectIdx
        }
        
        static func dataProvide(selectIdx: Int) -> [ShapeTypeViewModel] {
            return [ShapeTypeViewModel(type: .heart, selectIdx: selectIdx),
                    ShapeTypeViewModel(type: .note, selectIdx: selectIdx),
                    ShapeTypeViewModel(type: .blackboard, selectIdx: selectIdx)]
        }
    }
}
