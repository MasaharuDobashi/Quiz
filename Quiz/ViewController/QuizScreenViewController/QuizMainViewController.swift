//
//  QuizMainViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

// MARK: - QuizMainViewController


final class QuizMainViewController: UIViewController {
    
    // MARK: Properties

    /// スタートボタンや履歴ボタンを表示する画面
    private var quizMainView: QuizMainView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuizMainView()
        setNotificationCenter()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        quizMainView.isActiveQuiz = QuizModel.allFindQuiz(self, isSort: true)?.count != 0 ? true : false
        quizMainView.isQuizType = QuizCategoryModel.findAllQuizCategoryModel(self)?.count != 0 ? true : false
        quizMainView.isHistory = HistoryModel.allFindHistory(self).isEmpty ? false : true
    }
    
  
    
    func setQuizMainView() {
        quizMainView = QuizMainView(frame: UIScreen.main.bounds)
        quizMainView.delegate = self
        view.addSubview(quizMainView)
    }
    
    
    /// addObserverをセットする
    func setNotificationCenter() {
        #if DEBUG
        /// QuizManagementViewControllerでallDeleteがpostされたら履歴ボタンを更新する
        NotificationCenter.default.addObserver(self, selector: #selector(allDeleteFlag(notification:)), name: NSNotification.Name(rawValue: R.string.notifications.allDelete()), object: nil)
        #endif
        
        /// R.notification.ViewUpdate、R.notification.QuizUpdateがpostされたらViewWillAppearを呼ぶ
        NotificationCenter.default.addObserver(self, selector: #selector(callViewWillAppear(notification:)), name: NSNotification.Name(rawValue: R.string.notifications.quizUpdate()), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callViewWillAppear(notification:)), name: NSNotification.Name(rawValue: R.string.notifications.viewUpdate()), object: nil)
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



// MARK: - QuizMainViewDelegate

extension QuizMainViewController: QuizMainViewDelegate {
        
    /// クイズがあればクイズをスタートする、なければクイズの作成モーダルを表示する
    func quizStartButtonAction() {
        if quizMainView.isActiveQuiz {
            presentModalView(QuizScreenViewController())
        } else {
            presentModalView(QuizEditViewController(mode: .add))
        }
    }
    
    
    /// クイズのカテゴリがあれば選択画面に遷移する、なければクイズのカテゴリを作成モーダルを表示する
    func quizTypeButtonAction() {
        if quizMainView.isQuizType {
            pushTransition(QuizTypeSelectTableViewController())
        } else {
            presentModalView(QuizTypeEditViewController(typeid: nil, createTime: nil, mode: .add))
        }
    }
    
    /// 履歴画面を開く
    func historyButtonAction() {
        pushTransition(HistoryViewController())
    }
}
