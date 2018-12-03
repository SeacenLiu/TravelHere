//
//  FileNetworkTarget.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/3.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import Foundation
import Moya

struct FileNetworkTarget {
    let data: Data
    
    init(_ data: Data) {
        self.data = data
    }
}

extension FileNetworkTarget: NetworkTarget {
    var interface: NetworkInterface {
        return .fileUpload
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        let fileName = String(describing: data) + ".jpg"
        let fromData = MultipartFormData(provider: .data(data), name: "file", fileName: fileName, mimeType: "image/jpg")
        return .uploadMultipart([fromData])
    }
}
