//
//  quizEditViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/28.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

final class QuizEditViewController: UIViewController {
    
    // MARK: Properties
    
    private let config = Realm.Configuration(schemaVersion: 1)
    private var realm:Realm?
    
    /// クイズのID
    private var quzi_id:Int?
    
    /// 新規追加、編集、詳細の判別
    private var mode: ModeEnum = ModeEnum.add
    
    /// クイズを格納
    private var quizModel: QuizModel!
    private var quizTypeModel: [QuizTypeModel]! {
        didSet {
            quizEditView.quizTypeModel = quizTypeModel
        }
    }
    
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
        
        do {
            realm = try Realm(configuration: Realm.Configuration(schemaVersion: realmConfig))
        } catch {
            AlertManager().alertAction(viewController: self,
                                       title: nil,
                                       message: R.string.error.errorMessage,
                                       handler: { _ in
                return
            })
            return
        }
        
        quizTypeModel = [QuizTypeModel]()
        for model in (realm?.objects(QuizTypeModel.self))! {
            quizTypeModel.append(model)
        }
        
        view.addSubview(quizEditView)
        
        
    }
    
    
    
    // MARK: NavigationItem Func
    
    override func navigationItemAction() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
    }
    
    
    override func rightButtonAction(){
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
            NotificationCenter.default.post(name: Notification.Name(R.notification.ViewUpdate), object: nil)
        }
        
        
        NotificationCenter.default.post(name: Notification.Name(R.notification.QuizUpdate), object: nil)
    }
    
    
    /// Realmに新規追加
    private func addRealm(_ parameters: [String: Any]){
        let quizModel = QuizModel()
        let title:String = parameters[key.title] as! String
        let correctAnswer:String =  parameters[key.correctAnswer] as! String
        let incorrectAnswer1: String = parameters[key.incorrectAnswer1] as! String
        let incorrectAnswer2: String = parameters[key.incorrectAnswer2] as! String
        let incorrectAnswer3: String = parameters[key.incorrectAnswer3] as! String
        // TODO:
        let quizid: String? = quizEditView.typeid
        var quizType: QuizTypeModel?
        if quizid != nil {
            quizType = realm?.objects(QuizTypeModel.self)[Int(quizid!)!]
        } else {
            quizType = nil
        }
        
        let showHide: String = parameters[key.showHide] as! String
        
        
        guard let id:Int = realm?.objects(QuizModel.self).count else { return }
        
        quizModel.id = String(id)
        quizModel.quizTitle = title
        quizModel.trueAnswer = correctAnswer
        quizModel.falseAnswer1 = incorrectAnswer1
        quizModel.falseAnswer2 = incorrectAnswer2
        quizModel.falseAnswer3 = incorrectAnswer3
        quizModel.quizTypeModel = quizType
        quizModel.displayFlag = showHide
        
        
        
        do {
            try realm?.write() {
                realm?.add(quizModel)
            }
        } catch {
            AlertManager().alertAction(viewController: self, title: nil, message: R.string.error.errorMessage, handler: { _ in
                return
            })
            return
        }
        
        
    }
    
    
    /// アップデート
    private func updateRealm(_ parameters: [String:Any]){
        let title:String = parameters[key.title] as! String
        let correctAnswer:String =  parameters[key.correctAnswer] as! String
        let incorrectAnswer1: String = parameters[key.incorrectAnswer1] as! String
        let incorrectAnswer2: String = parameters[key.incorrectAnswer2] as! String
        let incorrectAnswer3: String = parameters[key.incorrectAnswer3] as! String
        // TODO:
        let quizid: String? = quizEditView.typeid
        var quizType: QuizTypeModel?
        if quizid != nil {
            quizType = realm?.objects(QuizTypeModel.self)[Int(quizid!)!]
        } else {
            quizType = nil
        }
        let showHide: String = parameters[key.showHide] as! String
        
        
        
        do {
            try realm?.write() {
                realm?.objects(QuizModel.self)[quzi_id!].quizTitle = title
                realm?.objects(QuizModel.self)[quzi_id!].trueAnswer = correctAnswer
                realm?.objects(QuizModel.self)[quzi_id!].falseAnswer1 = incorrectAnswer1
                realm?.objects(QuizModel.self)[quzi_id!].falseAnswer2 = incorrectAnswer2
                realm?.objects(QuizModel.self)[quzi_id!].falseAnswer3 = incorrectAnswer3
                realm?.objects(QuizModel.self)[quzi_id!].quizTypeModel = quizType
                realm?.objects(QuizModel.self)[quzi_id!].displayFlag = showHide
            }
        } catch {
            AlertManager().alertAction(viewController: self, title: nil, message: R.string.error.errorMessage, handler: { _ in
                return
            })
            return
        }
        
    }
    
    
    // MARK: Other
    
    private func quizModelAppend(quiz_id:Int){
        quizModel = QuizModel()
        quizModel = realm?.objects(QuizModel.self)[quiz_id]
    }
    
    
    
    /// 各項目のバリデーションを実施
    func validate(parameters:[String:Any]) -> Bool {
        
        
        if emptyValidate(viewController: self, title: parameters[key.title] as! String, message: "クイズのタイトルが未入力です。") == false {
            return false
        }
        
        if emptyValidate(viewController: self, title: parameters[key.correctAnswer] as! String, message: "正解が未入力です。") == false {
            return false
        }
        if emptyValidate(viewController: self, title: parameters[key.incorrectAnswer1] as! String, message: "不正解1が未入力です。") == false {
            return false
        }
        if emptyValidate(viewController: self, title: parameters[key.incorrectAnswer2] as! String, message: "不正解2が未入力です。") == false {
            return false
        }
        if emptyValidate(viewController: self, title: parameters[key.incorrectAnswer2] as! String, message: "不正解3が未入力です。") == false {
            return false
        }
        
        return true
    }
    
    
    
    
    
}

