//
//  quizEditViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/28.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit


class QuizEditViewController: UIViewController {
    
    private var quizEditView:QuizEditView?
    private var quzi_id:Int?
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(quzi_id:Int){
        self.init(nibName: nil, bundle: nil)
        self.quzi_id = quzi_id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
        

        quizEditView = QuizEditView(frame: frame_Size(viewController: self),quiz_id: quzi_id)
        self.view.addSubview(quizEditView!)
        
    }

    @objc private func rightButtonAction(){
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
        
        
        if quzi_id == nil {
            quizEditView?.addRealm()
        } else {
            quizEditView?.updateRealm()
        }
        leftButtonAction()
    }
}
