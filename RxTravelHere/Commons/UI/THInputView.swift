//
//  THInputView.swift
//  TravelHere
//
//  Created by SeacenLiu on 2018/5/21.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class THInputView: UIView {
    
    typealias THSendBlock = (_ text: String)->()
    // MARK: - public
    public var handleSend: THSendBlock?
    
    /// 是否显示
    public var isShow = false
    
    /// 是否可用
    public var isEnable = true
    
    /// 是否持续显示
    public var isContinueShow = false
    
    public func show(with placeHolder: String? = nil) {
        if isEnable == false { return }
        if let str = placeHolder {
            textView.placeHolder = str
        } else {
            textView.placeHolder = ""
        }
        if let currentView = UIViewController.currentController?.view {
            currentView.addSubview(self)
            textView.becomeFirstResponder()
        }
    }
    
    public func dismiss() {
        if isEnable == false { return }
        if isShow {
            textView.endEditing(true)
        }
    }
    
    // MARK: - action
    @objc private func keyboardWillShowAction(note: Notification) {
        guard let dict = note.userInfo else { return }
        if isEnable == false { return }
        let keyboardF = dict[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let duration = dict[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let curveNum = dict[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let curve = UIView.AnimationOptions.init(rawValue: curveNum)
        let keyboardH = keyboardF.size.height
        
        var newFrame = frame
        newFrame.origin.y = UIScreen.main.bounds.height - keyboardH - bounds.height
        
        UIView.animate(withDuration: duration, delay: 0, options: [curve], animations: {
            self.frame = newFrame
        }) { _ in
            // post notification
            NotificationCenter.default.post(name: .inPuterFrameDidChangeNotification, object: self)
        }
        
        originY = newFrame.origin.y
        
        isShow = true
    }
    
    @objc private func keyboardWillHideAction(note: Notification) {
        guard let dict = note.userInfo else { return }
        if isEnable == false { return }
        if isContinueShow { return }
        let duration = dict[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        var newFrame = frame
        newFrame.origin.y = UIScreen.main.bounds.height
        UIView.animate(withDuration: duration, animations: {
            self.frame = newFrame
        }) { (_) in
            // 收起键盘之后就隐藏掉输入框
            self.removeFromSuperview()
        }
        
        inputViewH = bounds.height
        isShow = false
    }

    // MARK: - init
    init(handleSend: @escaping THSendBlock) {
        self.handleSend = handleSend
        super.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-inputViewH, width: UIScreen.main.bounds.width, height: inputViewH))
        // set up ui
        backgroundColor = #colorLiteral(red: 0, green: 0.7176470588, blue: 0.8039215686, alpha: 1)
        textView.frame = CGRect(x: 24, y: 5, width: UIScreen.main.bounds.width-48, height: 36)
        addSubview(textView)
        
        // notification center
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShowAction(note:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHideAction(note:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // delegate && add target
        textView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        log("THInputView deinit")
    }
    
    // MARK: - private
    private lazy var textView: THTextView = {
        let tv = THTextView()
        tv.textFont = UIFont.systemFont(ofSize: 16.0)
        tv.layer.cornerRadius = 10
        tv.layer.masksToBounds = true
        tv.tintColor = #colorLiteral(red: 0.5843137255, green: 0.262745098, blue: 0.8588235294, alpha: 1)
        tv.returnKeyType = .send
        return tv
    }()
    
    private var originY: CGFloat = 0
    
    private var inputViewH: CGFloat = 46
    
}

extension THInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let tv = textView as? THTextView {
            tv.isEdit = textView.text.count != 0
        }
        
        let height: CGFloat = textView.contentSize.height
        
        var newFrame = frame
        newFrame.size.height = height + 10.0
        newFrame.origin.y = originY - (newFrame.size.height-inputViewH)
        
        var newTVF = textView.frame
        newTVF.size.height = height

        frame = newFrame
        textView.frame = newTVF
        // 解决自适应高度UITextContainerView抖动问题
        textView.scrollRangeToVisible(textView.selectedRange)
        
        // post notification
        NotificationCenter.default.post(name: .inPuterFrameDidChangeNotification, object: self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if let callBack = handleSend {
                callBack(textView.text)
            }
            textView.text = ""
            if let tv = textView as? THTextView {
                tv.isEdit = false
            }
            return false
        } else {
            return true
        }
    }
}

extension Notification.Name {
    static let inPuterFrameDidChangeNotification = Notification.Name(rawValue: "com.seacen.app.inPuterFrameDidChangeNotification")
}
