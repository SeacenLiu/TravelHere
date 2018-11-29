//
//  View.swift
//  RxTravelHere
//
//  Created by SeacenLiu on 2018/11/29.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import UIKit

extension Account.Edit {
    final class View: UIViewController {
        private var _editView: EditInfoView { return view as! EditInfoView }
        
        override func loadView() {
            view = EditInfoView.nibView()
        }
    }
}

extension Account.Edit.View {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

final class EditInfoView: UIView {
    
}
