//
//  UserCenter.View.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/12/17.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UserCenter {
    internal class View: UIViewController {
        private var _userCenterView: UserCenterView { return view as! UserCenterView }
        let _disposeBag = DisposeBag()
        
        override func loadView() {
            view = UserCenterView.nibView()
        }
        
        private lazy var _viewModel = ViewModel()
        
        static func viewForNavigation() -> MainNavigationController {
            return MainNavigationController(rootViewController: View())
        }
        
        deinit {
            log("UserCenter.View deinit")
        }
    }
}

extension UserCenter.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        _viewModel.avatarImg
            .drive(_userCenterView.avatarImg.rx.image)
            .disposed(by: _disposeBag)
        
        _viewModel.name
            .drive(_userCenterView.nameLb.rx.text)
            .disposed(by: _disposeBag)
        
        _userCenterView.closeBtn.rx.tap
            .bind(to: rx.dismissAction)
        .disposed(by: _disposeBag)
    }
    
    func setupUI() {
        let myRecordView = UserCenter.MyRecord.View()
        let interactionView = UserCenter.Interaction.View()
        
        addChild(myRecordView)
        addChild(interactionView)
        
        if let contentView = _userCenterView.sliderView {
            contentView.titleNormalColor = .lightGray
            contentView.titleSelectedColor = .darkText
            contentView.sliderColor = .gray
            contentView.sliderWidth = 60
            contentView.sliderHeight = 2
            contentView.titles = ["我的留言", "评论互动"]
            contentView.contentViews = [myRecordView.view, interactionView.view]
            //        let count = THRedPointManager.shared.unreadInteractions.count
            //        contentView.redPoints = [0, count]
        }
    }
}
