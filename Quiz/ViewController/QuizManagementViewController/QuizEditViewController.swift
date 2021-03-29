//
//  quizEditViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/28.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

final class QuizEditViewController: UIViewController {
    
    // MARK: Properties
    
    /// クイズのID
    private var quiz_id: String?
    
    private var createTime: String?
    
    /// 新規追加、編集、詳細の判別
    private var mode: ModeEnum = ModeEnum.add
    
    /// クイズを格納
    private var quizModel: QuizModel!
    
    ///  カテゴリを格納
    private var quizCategoryModel: [QuizCategoryModel]!
    
    
    
    private lazy var quizEditView: QuizEditView = {
        switch mode {
        case .add:
            let quizEditView = QuizEditView(frame: frame, style: .grouped, mode: mode)
            return quizEditView
        case .edit, .detail:
            quizModelAppend()
            let quizEditView = QuizEditView(frame: frame, style: .grouped, quizModel: quizModel, mode: mode)
            quizEditView.quizTypeModel = quizCategoryModel
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
    convenience init(quzi_id: String, createTime: String, mode: ModeEnum){
        self.init(nibName: nil, bundle: nil)
        self.quiz_id = quzi_id
        self.createTime = createTime
        self.mode = mode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem()
        initQuizEditView()
    }
    
    
    
    /// QuizEditViewの初期化
    private func initQuizEditView() {
        switch mode {
        case .add:
            quizEditView = QuizEditView(frame: frame, style: .grouped, mode: mode)
        case .edit, .detail:
            quizModelAppend()
            quizEditView = QuizEditView(frame: frame, style: .grouped, quizModel: quizModel, mode: mode)
            debugPrint(object: quizModel)
        }
        quizEditView.quizTypeModel = QuizCategoryModel.findAllQuizCategoryModel(self)
        view.addSubview(quizEditView)
    }
    
    
    // MARK: NavigationItem Func
    
    override func setNavigationBarItem() {
        super.setNavigationBarItem()
        if mode == .detail {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(detailRightButtonAction))
        }
    }
    
    
    override func rightNaviBarButtonAction(){
        let parameters: [String:Any] = quizEditView.getParameters()
        if validate(parameters: parameters) == false { return }
        
        realmAction(parameters: parameters) {
            postNotificationCenter()
        }
    }
    
    
    @objc func detailRightButtonAction() {
        AlertManager.createActionSheet(self, message: "このクイズをどうしますか？", didTapEditButton: { [weak self] _ in
            self?.pushTransition(QuizEditViewController(quzi_id: self?.quizModel.id ?? "", createTime: self?.quizModel.createTime ?? "", mode: .edit))
            
        }, didTapDeleteButton: { _ in
            self.deleteQuiz { [weak self] in
                self?.leftNaviBarButtonAction()
            }
        })
    }
    
    
    
    
    
    // MARK: Realm Func
    
    private func realmAction(parameters: [String: Any], completion: () ->Void) {
        
        if mode == .add {
            addRealm(parameters) {
                AlertManager.alertAction( self, title: nil, message: "問題を作成しました", didTapCloseButton: { [weak self] Void in
                    self?.leftNaviBarButtonAction()
                })
            }
        } else if mode == .edit {
            updateRealm(parameters) {
                AlertManager.alertAction(self, title: nil, message: "問題を更新しました", didTapCloseButton: { [weak self] Void in
                    self?.leftNaviBarButtonAction()
                })
            }
        }
        
        completion()

    }
    
    
    /// Realmに新規追加
    private func addRealm(_ parameters: [String: Any], completion: () ->Void) {
        QuizModel.addQuiz(self, parameters: parameters)
        completion()
    }
    
    
    /// アップデート
    private func updateRealm(_ parameters: [String:Any], completion: () -> Void) {
        QuizModel.updateQuiz(self, parameters: parameters, id: quiz_id! , createTime: createTime)
        completion()
    }
    
    
    /// クイズの削除
    private func deleteQuiz(completion: () -> Void) {
        QuizModel.deleteQuiz(self, id: quizModel.id, createTime: quizModel.createTime ?? "")
        completion()
    }
    
    /// クイズを一件取得
    private func quizModelAppend() {
        quizModel = QuizModel.findQuiz(self, quizid: quiz_id ?? "", createTime: createTime)
    }
    
    
    // MARK: Other 
    

    /// 各項目のバリデーションを実施
    func validate(parameters:[String:Any]) -> Bool {
        
        
        if emptyValidate(viewController: self, title: parameters[ParameterKey().title] as! String, message: "クイズのタイトルが未入力です。") == false {
            return false
        }
        
        if emptyValidate(viewController: self, title: parameters[ParameterKey().correctAnswer] as! String, message: "正解が未入力です。") == false {
            return false
        }
        if emptyValidate(viewController: self, title: parameters[ParameterKey().incorrectAnswer1] as! String, message: "不正解1が未入力です。") == false {
            return false
        }
        if emptyValidate(viewController: self, title: parameters[ParameterKey().incorrectAnswer2] as! String, message: "不正解2が未入力です。") == false {
            return false
        }
        if emptyValidate(viewController: self, title: parameters[ParameterKey().incorrectAnswer3] as! String, message: "不正解3が未入力です。") == false {
            return false
        }
        
        
        if (QuizCategoryModel.findAllQuizCategoryModel(self)?.count)! > 0 {
            if emptyValidate(viewController: self, title: parameters[ParameterKey().quizType] as! String, message: "カテゴリが未選択です") == false {
                return false
            }
        }
        
        
        return true
    }
    
    
    private func postNotificationCenter() {
        NotificationCenter.default.post(name: Notification.Name(R.string.notifications.quizUpdate()), object: nil)
    }
    
    
    
}

