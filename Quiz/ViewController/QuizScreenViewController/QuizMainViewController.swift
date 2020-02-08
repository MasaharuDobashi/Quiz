//
//  QuizMainViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift
import Rswift

// MARK: - QuizMainViewController


class QuizMainViewController: UIViewController, QuizMainViewDelegate {
    
    // MARK: Properties
    
    /// Realmのスキームバージョンを設定
    private var realm:Realm?
    
    
    /// スタートボタンや履歴ボタンを表示する画面
    private lazy var quizMainView:QuizMainView = {
        let quizMainView: QuizMainView = QuizMainView(frame: frame_Size(self))
        quizMainView.delegate = self
        
        return quizMainView
    }()
    
    
    
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
        
        setNotificationCenter()
        
        view.addSubview(quizMainView)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        quizMainView.isActiveQuiz = realm?.objects(QuizModel.self).count != 0 ? true : false
        quizMainView.isQuizType = realm?.objects(QuizTypeModel.self).count != 0 ? true : false
        quizMainView.isHistory = realm?.objects(HistoryModel.self).count != 0 ? true : false
        
    }
    
    
    // MARK: QuizMainViewDelegate
    
    
    /// クイズがあればクイズをスタートする、なければクイズの作成モーダルを表示する
    func quizStartButtonAction() {
        if quizMainView.isActiveQuiz {
            presentModalView(QuizScreenViewController())
            
        } else {
            presentModalView(QuizEditViewController(mode: .add))
            
        }
    }
    
    
    /// クイズの種類があれば選択画面に遷移する、なければクイズの種類を作成モーダルを表示する
    func quizTypeButtonAction() {
        if quizMainView.isQuizType {
            pushTransition(QuizTypeSelectTableViewController())
            
        } else {
            presentModalView(QuizTypeEditViewController(typeid: nil, mode: .add))
            
        }
    }
    
    /// 履歴画面を開く
    func historyButtonAction() {
        pushTransition(HistoryViewController())
    }
    
    
    
    
    /// addObserverをセットする
    func setNotificationCenter() {
        #if DEBUG
        /// QuizManagementViewControllerでallDeleteがpostされたら履歴ボタンを更新する
        NotificationCenter.default.addObserver(self, selector: #selector(allDeleteFlag(notification:)), name: NSNotification.Name(rawValue: R.notification.AllDelete), object: nil)
        #endif
        
        
        /// R.notification.ViewUpdate、R.notification.QuizUpdateがpostされたらViewWillAppearを呼ぶ
        NotificationCenter.default.addObserver(self, selector: #selector(callViewWillAppear(notification:)), name: NSNotification.Name(rawValue: R.notification.QuizUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callViewWillAppear(notification:)), name: NSNotification.Name(rawValue: R.notification.ViewUpdate), object: nil)
    }
    
    
    
    // MARK: Notification Action
    
    #if DEBUG
    /// 履歴ボタンを非表示する
    @objc func allDeleteFlag(notification: Notification){
        quizMainView.isHistory = false
        quizMainView.historyButtonColorChange()
        viewWillAppear(false)
    }
    #endif
    
    
    
    
    /// postViewWillAppearを呼ぶ
    /// - Parameter notification: ViewUpdate、QuizUpdateがpostされた時
    @objc func callViewWillAppear(notification: Notification) {
        self.viewWillAppear(true)
    }
    
}

