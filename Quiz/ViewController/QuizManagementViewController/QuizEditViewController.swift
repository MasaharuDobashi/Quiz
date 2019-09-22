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
    private var quzi_id:Int?
    private var mode: ModeEnum = ModeEnum.add
    private var quizModel: [QuizModel]!
    
    let key:ParameterKey = ParameterKey()
    
    
    private lazy var quizEditView:QuizEditView = {
        
        switch mode {
        case .add:
            navigationItemAction()
            let quizEditView = QuizEditView(frame: frame_Size(self), style: .grouped, mode: mode)
            return quizEditView
        case .edit:
            navigationItemAction()
            quizModelAppend(quiz_id: quzi_id!)
            let quizEditView = QuizEditView(frame: frame_Size(self), style: .grouped,quizModel: quizModel, mode: mode)
            debugPrint(object: quizModel)
            
            return quizEditView
        case .detail:
            quizModelAppend(quiz_id: quzi_id!)
            let quizEditView = QuizEditView(frame: frame_Size(self), style: .grouped,quizModel: quizModel, mode: mode)
            debugPrint(object: quizModel)
            
            return quizEditView
            
        }
        
    }()
    
    
    
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
        
        
        view.addSubview(quizEditView)
        
    }
    
    // MARK: - Private func
    // MARK: NavigationItem Func
    
    private func navigationItemAction(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
    }
    
    
    @objc private func rightButtonAction(){
        let parameters: [String:Any] = quizEditView.getParameters()
        if validate(parameters: parameters) == false { return }
        
        realmAction(parameters: parameters)
    }
    
    
    
    // MARK: Realm Func
    
    private func realmAction(parameters: [String: Any]){
        
        if mode == .add {
            addRealm(parameters)
            AlertManager().alertAction(viewController: self, title: nil, message: "問題を作成しました", handler: { [weak self] Void in
                self?.leftButtonAction()
            })
        } else if mode == .edit {
            updateRealm(parameters)
            AlertManager().alertAction(viewController: self, title: nil, message: "問題を更新しました", handler: { [weak self] Void in
                self?.leftButtonAction()
            })
        }
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.post(name: Notification.Name("quizUpdate"), object: nil)
        }
        
    }
    
    
    /// Realmに新規追加
    private func addRealm(_ parameters: [String: Any]){
        let quizModel = QuizModel()
        let title:String = parameters[key.title] as! String
        let correctAnswer:String =  parameters[key.correctAnswer] as! String
        let incorrectAnswer1: String = parameters[key.incorrectAnswer1] as! String
        let incorrectAnswer2: String = parameters[key.incorrectAnswer2] as! String
        let incorrectAnswer3: String = parameters[key.incorrectAnswer3] as! String
        let showHide: String = parameters[key.showHide] as! String
        
        
        quizModel.id = String(realm.objects(QuizModel.self).count)
        quizModel.quizTitle = title
        quizModel.trueAnswer = correctAnswer
        quizModel.falseAnswer1 = incorrectAnswer1
        quizModel.falseAnswer2 = incorrectAnswer2
        quizModel.falseAnswer3 = incorrectAnswer3
        quizModel.displayFlag = showHide
        
        try! realm.write() {
            realm.add(quizModel)
        }
    }
    
    
    /// アップデート
    private func updateRealm(_ parameters: [String:Any]){
        let title:String = parameters[key.title] as! String
        let correctAnswer:String =  parameters[key.correctAnswer] as! String
        let incorrectAnswer1: String = parameters[key.incorrectAnswer1] as! String
        let incorrectAnswer2: String = parameters[key.incorrectAnswer2] as! String
        let incorrectAnswer3: String = parameters[key.incorrectAnswer3] as! String
        let showHide: String = parameters[key.showHide] as! String
        
        try! realm.write() {
            realm.objects(QuizModel.self)[quzi_id!].quizTitle = title
            realm.objects(QuizModel.self)[quzi_id!].trueAnswer = correctAnswer
            realm.objects(QuizModel.self)[quzi_id!].falseAnswer1 = incorrectAnswer1
            realm.objects(QuizModel.self)[quzi_id!].falseAnswer2 = incorrectAnswer2
            realm.objects(QuizModel.self)[quzi_id!].falseAnswer3 = incorrectAnswer3
            realm.objects(QuizModel.self)[quzi_id!].displayFlag = showHide
        }
    }
    
    
    // MARK: Other
    
    private func quizModelAppend(quiz_id:Int){
        quizModel = [QuizModel]()
        
        quizModel.append(realm.objects(QuizModel.self)[quiz_id])
    }
    
    
    
    /// 各項目のバリデーションを実施
    func validate(parameters:[String:Any]) -> Bool {
        
        
        if emptyValidate(title: parameters[key.title] as! String, message: "クイズのタイトルが未入力です。") == false {
            return false
        }
        
        if emptyValidate(title: parameters[key.correctAnswer] as! String, message: "正解が未入力です。") == false {
            return false
        }
        if emptyValidate(title: parameters[key.incorrectAnswer1] as! String, message: "不正解1が未入力です。") == false {
            return false
        }
        if emptyValidate(title: parameters[key.incorrectAnswer2] as! String, message: "不正解2が未入力です。") == false {
            return false
        }
        if emptyValidate(title: parameters[key.incorrectAnswer2] as! String, message: "不正解3が未入力です。") == false {
            return false
        }
        
        return true
    }
    
    
    
    /// 文字数が0以上かどうかバリデーションチェック
    ///
    /// - Parameters:
    ///   - title: チェックするテキスト
    ///   - message: エラー時のアラートメッセージ
    /// - Returns: バリデーションの結果
    func emptyValidate(title: String, message: String) -> Bool {
        if title.count == 0 {
            AlertManager().alertAction(viewController: self, title: nil, message: message, handler: {_ -> Void in})
            return false
        }
        return true
    }
    
    
}

