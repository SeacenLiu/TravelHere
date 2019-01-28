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
import SVProgressHUD

extension Record.Edit {
    struct Result {
        let model: Record.Detail
        let success: Bool
        
        static var empty: Result {
            return Result(model: .empty, success: false)
        }
    }
    
    internal class ViewModel {
        typealias Content = (text: String, img: String, type: Int, location: SearchResult)
        
        let publishResult: Driver<Result>
        let image: Driver<UIImage>
        let typeData: Driver<[ShapeTypeViewModel]>
        let publishEnable: Driver<Bool>
        
        init(input: (text: Driver<String>, img: Driver<UIImage?>, type: Driver<Int>, location: Driver<SearchResult>, doneTap: Signal<Void>)) {
            
            let provider = MoyaProvider<Record.NetworkTarget>()
            let imageProvider = MoyaProvider<FileNetworkTarget>()

            publishEnable = input.location
                .map { _ in true }
                .startWith(false)
                .asDriver(onErrorJustReturn: false)
            typeData = input.type.map { ShapeTypeViewModel.dataProvide(selectIdx: $0) }
            image = input.img.filter {$0 != nil}.map { $0! }
            
            let content = Driver.combineLatest(input.text, input.img, input.type.startWith(0), input.location)
            
            publishResult = input.doneTap.withLatestFrom(content)
                .flatMapLatest { (text, img, type, location) ->  Driver<NetworkValid<Content>> in
                    guard let img = img else { return .of(.success(value: (text, "", type, location))) }
                    return imageProvider.rx
                        .request(FileNetworkTarget(img.imageJpgData!))
                        .map(NetworkResponse<ImageInfo>.self)
                        .map { .success(value: (text, $0.data.path, type, location)) }
                        .asDriver(onErrorJustReturn: .failure)
                }
                .flatMapLatest { network -> Driver<Result> in
                    switch network {
                    case let .success(content):
                        return provider.rx
                            .request(.uploadRecord(
                                messageContent: content.text,
                                modelId: content.type,
                                messageLongitude: content.location.longitude,
                                messageLatitude: content.location.latitude,
                                messageImage: content.img,
                                messageAddress: content.location.address))
                            .map(NetworkResponse<Record.Detail>.self)
                            .do(onSuccess: { _ in
                                // TODO: - 通知地图和AR模块增加留言
                            })
                            .map { Result(model: $0.data, success: $0.code == .success) }
                            .asDriver(onErrorJustReturn: .empty)
                    case .failure:
                        return .just(.empty)
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
