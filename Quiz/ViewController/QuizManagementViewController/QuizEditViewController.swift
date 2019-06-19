//
//  quizEditViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/28.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

class QuizEditViewController: UIViewController {
    
    // MARK: Properties
    private let config = Realm.Configuration(schemaVersion: 1)
    private var realm:Realm!
    private var quizEditView:QuizEditView?
    private var quzi_id:Int?
    private var mode: ModeEnum = ModeEnum.add
    private var quizModel: [QuizModel]!
  
    
    // MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    } 
    
    
    /// add Init
    convenience init(mode: ModeEnum){
        self.init(nibName: nil, bundle: nil)
        self.mode = mode
    }
    
    
    /// edit,detail Init
    convenience init(quzi_id:Int, mode: ModeEnum){
        self.init(nibName: nil, bundle: nil)
        self.quzi_id = quzi_id
        self.mode = mode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm(configuration: config)
        switch mode {
        case .add:
            navigationItemAction()
            quizEditView = QuizEditView(frame: frame_Size(self), style: .grouped, mode: mode)
        case .edit:
            navigationItemAction()
            quizModelAppend(quiz_id: quzi_id!)
            quizEditView = QuizEditView(frame: frame_Size(self), style: .grouped,quizModel: quizModel, mode: mode)
            #if DEBUG
            print(quizModel!)
            #endif
        case .detail:
            quizModelAppend(quiz_id: quzi_id!)
            quizEditView = QuizEditView(frame: frame_Size(self), style: .grouped,quizModel: quizModel, mode: mode)
            #if DEBUG
            print(quizModel!)
            #endif
        }

        self.view.addSubview(quizEditView!)
        
    }
    
    // MARK: - Private func
    // MARK: NavigationItem Func
    
    private func navigationItemAction(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
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
        
        
        if mode == .add {
            addRealm()
            AlertManager().alertAction(viewController: self, title: nil, message: "問題を作成しました", handler: { [weak self] Void in
                self?.leftButtonAction()
            })
        } else if mode == .edit {
            updateRealm()
            AlertManager().alertAction(viewController: self, title: nil, message: "問題を更新しました", handler: { [weak self] Void in
                self?.leftButtonAction()
            })
        }
    }
    
    
    // MARK: Realm Func
    private func addRealm(){
        let quizModel = QuizModel()
        quizModel.id = String(realm.objects(QuizModel.self).count)
        quizModel.quizTitle = (quizEditView?.titleTextField.text)!
        quizModel.trueAnswer = (quizEditView?.true_TextField.text)!
        quizModel.falseAnswer1 = (quizEditView?.false1_TextField.text)!
        quizModel.falseAnswer2 = (quizEditView?.false2_textField.text)!
        quizModel.falseAnswer3 = (quizEditView?.false3_textField.text)!
        quizModel.displayFlag = quizEditView?.displaySwitch.isOn == true ? "0" : "1"
        
        
        try! realm.write() {
            realm.add(quizModel)
        }
    }
    
    private func updateRealm(){
        try! realm.write() {
            realm.objects(QuizModel.self)[quzi_id!].quizTitle = (quizEditView?.titleTextField.text)!
            realm.objects(QuizModel.self)[quzi_id!].trueAnswer = (quizEditView?.true_TextField.text)!
            realm.objects(QuizModel.self)[quzi_id!].falseAnswer1 = (quizEditView?.false1_TextField.text)!
            realm.objects(QuizModel.self)[quzi_id!].falseAnswer2 = (quizEditView?.false2_textField.text)!
            realm.objects(QuizModel.self)[quzi_id!].falseAnswer3 = (quizEditView?.false3_textField.text)!
            realm.objects(QuizModel.self)[quzi_id!].displayFlag = quizEditView?.displaySwitch.isOn == true ? "0" : "1"
        }
    }
    
    
    // MARK: Other
    
    private func quizModelAppend(quiz_id:Int){
        quizModel = [QuizModel]()
        
        quizModel.append(realm.objects(QuizModel.self)[quiz_id])
    }
}
