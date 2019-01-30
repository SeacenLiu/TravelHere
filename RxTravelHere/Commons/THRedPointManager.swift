//
//  THRedPointManager.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/7/21.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation
import RxSwift

private let fileMainName = "RedPoint.plist"

class THRedPointManager {
    static let shared = THRedPointManager()
    
    private init() { }
    
    var unreadDriver: Observable<[Int]> {
        return unreadSubject.asObservable()
    }
    var unreadArray: [Int] {
        return (try? unreadSubject.value()) ?? [Int]()
    }
    private lazy var unreadSubject: BehaviorSubject<[Int]> = {
        let array = self.getDataFromFile() ?? [Int]()
        return BehaviorSubject<[Int]>(value: array)
    }()
    
    public func addComment(model: Comment.Detail) {
        // 防止重复
        var unreadInteractions = unreadArray
        let filter = unreadInteractions.filter { $0 == model.id }
        if filter.count > 0 {
            log("出现重复")
        }
        else {
            unreadInteractions.append(model.id)
        }
        unreadSubject.onNext(unreadInteractions)
        // 保存
        saveFile(with: unreadInteractions)
    }
    
    public func readComment(cid: Int, completeHandler: (()->())?) {
        // 点击进去 根据 CommentId 去除小红点
        var unreadInteractions = unreadArray
        unreadInteractions = unreadInteractions.filter {$0 != cid}
        // 保存
        saveFile(with: unreadInteractions)
        completeHandler?()
    }
    
    public func isUnreadComment(cid: Int) -> Bool {
        let unreadInteractions = unreadArray
        let array = unreadInteractions.filter {$0 == cid}
        return !(array.count > 0)
    }
    
    public func setupUI(
        model: Comment.Detail,
        handler: ((_ isRead: Bool)->())?) {
        let unreadInteractions = unreadArray
        let filter = unreadInteractions.filter { $0 == model.id }
        if filter.count > 0 {
            log("这是未读信息")
            handler?(false)
        }
        else {
            log("这是已读信息")
            handler?(true)
        }
    }
    
}

/// 文件存储
private extension THRedPointManager {
    var filePath: String? {
        guard let user = Account.Manager.shared.user else { return nil }
        let documentPath = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).last!
        return documentPath + "/" + user.userId + fileMainName
    }
    
    func saveFile(with array: [Int]) {
        guard let filePath = filePath else { return }
        let array = array as NSArray
        array.write(toFile: filePath, atomically: true)
    }
    
    func getDataFromFile() -> [Int]? {
        guard let filePath = filePath,
            let models = NSArray(contentsOfFile: filePath) as? [Int]
            else { return nil }
        return models
    }
}
