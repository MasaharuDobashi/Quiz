//
//  quizEditViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/28.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit


class QuizEditViewController: UIViewController {
    
    var quizEditView:QuizEditView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
        

        quizEditView = QuizEditView(frame: frame_Size(viewController: self))
        self.view.addSubview(quizEditView!)
        
    }
    
    @objc func leftButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }

    @objc func rightButtonAction(){
        if quizEditView?.titleTextField.text?.count == 0 {
            AlertManager().alertAction(viewController: self, title: nil, message: "クイズのタイトルが未入力です。", handler: {_ -> Void in})
            return
        }
     
        if quizEditView?.titleTextField.text?.count == 0 {
            AlertManager().alertAction(viewController: self, title: nil, message: "正解が未入力です。", handler: {_ -> Void in})
            return
        }
        
        if quizEditView?.false1_TextField.text?.count == 0 {
            AlertManager().alertAction(viewController: self, title: nil, message: "不正解1が未入力です。", handler: {_ -> Void in})
            return
        }
        
        if quizEditView?.false2_textField.text?.count == 0 {
            AlertManager().alertAction(viewController: self, title: nil, message: "不正解2が未入力です。", handler: {_ -> Void in})
            return
        }
        
        if quizEditView?.false3_textField.text?.count == 0 {
            AlertManager().alertAction(viewController: self, title: nil, message: "不正解3が未入力です。", handler: {_ -> Void in})
            return
        }
        
        
        quizEditView?.addRealm()
    }
}
