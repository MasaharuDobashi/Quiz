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
    
    // MARK: @IBOutlet

    /// クイズスタートボタン
    ///
    /// - クイズがなければクイズ作成モーダルを表示する
    /// - クイズを開始する
    @IBOutlet weak var quizStartButton: UIButton! {
        didSet {
            quizStartButton.accessibilityIdentifier = "quizStartButton"
            quizStartButton.buttonHeight(multiplier: 0.06, cornerRadius: 8)
            quizStartButton.highlightAction()
        }
    }
    

    
    /// クイズのカテゴリ
    ///
    /// - クイズのカテゴリがなければクイズのカテゴリ作成モーダルを表示する
    /// - クイズのカテゴリ選択画面に遷移する
    @IBOutlet weak var quizTypeButton: UIButton! {
        didSet {
            quizTypeButton.accessibilityIdentifier = "typeButton"
            quizTypeButton.buttonHeight(multiplier: 0.06, cornerRadius: 8)
            quizTypeButton.highlightAction()
        }
    }
    
    
    
    /// 履歴ボタン
    ///
    /// - 履歴がなければ非表示
    /// - 履歴がなければ表示
    @IBOutlet weak var historyButton: UIButton! {
        didSet {
            historyButton.accessibilityIdentifier = "historyButton"
            historyButton.buttonHeight(multiplier: 0.06, cornerRadius: 8)
            historyButton.highlightAction()
        }
    }
    

    // MARK: @IBAction
    
    /// スタートボタンのタップアクション
    /// クイズが作成済みならクイズの画面をモーダルで表示する
    /// クイズがなければ作成画面をモーダル表示
    @IBAction func didTapQuizStartButton(_ sender: UIButton) {
        if isActiveQuiz {
            presentModalView(QuizScreenViewController())
        } else {
            presentModalView(QuizEditViewController(mode: .add))
        }
    }
    
    
    /// カテゴリボタンのタップアクション
    /// カテゴリが作成済みならカテゴリの選択画面表示する
    /// カテゴリがなければ作成画面をモーダル表示
    @IBAction func didTapQuizTypeButton(_ sender: UIButton) {
        if isQuizType {
            pushTransition(QuizTypeSelectTableViewController())
        } else {
            presentModalView(QuizTypeEditViewController(typeid: nil, createTime: nil, mode: .add))
        }
    }
    
    
    /// 履歴画面に遷移する
    @IBAction func didTapHistoryButton(_ sender: UIButton) {
        pushTransition(HistoryViewController())
    }
    
    
    // MARK: Properties
    
    /// クイズがあるかないかのフラグ
    ///
    /// - true: クイズがあればquizStartButtonをクイズスタートにする
    /// - false: クイズがなければquizStartButtonをクイズ作成ボタンにする
    private var isActiveQuiz: Bool = false {
        didSet {
            startButtonColorChange()
        }
    }
    
    
    /// 履歴があるかないかのフラグ
    ///
    /// - true:  historyButtonを表示する
    /// - false:  historyButtonを非表示にする
    private var isHistory: Bool = false {
        didSet {
            historyButtonColorChange()
        }
    }
    
    
    /// クイズのカテゴリがあるかないかのフラグ
    ///
    /// - true:  historyButtonを表示する
    /// - false:   historyButtonを非表示にする
    private var isQuizType: Bool = false {
        didSet {
            typeButtonColorChange()
        }
    }
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotificationCenter()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isActiveQuiz = QuizModel.allFindQuiz(self, isSort: true)?.count != 0 ? true : false
        isQuizType = QuizCategoryModel.findAllQuizCategoryModel(self)?.count != 0 ? true : false
        isHistory = HistoryModel.allFindHistory(self).isEmpty ? false : true
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
    /// viewWillAppearで各ボタンの表示フラグを切り替える
    @objc func allDeleteFlag(notification: Notification){
        viewWillAppear(false)
    }
    #endif
    
    
    
    
    /// postViewWillAppearを呼ぶ
    /// - Parameter notification: ViewUpdate、QuizUpdateがpostされた時
    @objc func callViewWillAppear(notification: Notification) {
        self.viewWillAppear(true)
    }
    
}




// MARK: - ButtonColorChange

extension QuizMainViewController {
        
    /// クイズスタートボタンの色を変える
    func startButtonColorChange(){
        if isActiveQuiz == false {
            quizStartButton.setTitle("クイズを作成", for: .normal)
            quizStartButton.backgroundColor = R.color.dawnpink()
        } else {
            quizStartButton.setTitle("クイズスタート", for: .normal)
            quizStartButton.backgroundColor = R.color.geranium()
        }
    }
    
    /// quizTypeButtonをaddSubViewする
    ///
    /// - isQuizType == true: クイズの選択ボタンをaddSubViewする
    /// - isQuizType == false: クイズの選択をremoveFromSuperviewする
    func typeButtonColorChange(){
        if isQuizType == true {
            quizTypeButton.setTitle("カテゴリの選択", for: .normal)
            quizTypeButton.backgroundColor = R.color.geranium()
        } else {
            quizTypeButton.setTitle("クイズのカテゴリを作成", for: .normal)
            quizTypeButton.backgroundColor = R.color.dawnpink()
        }
    }
    
    
    /// 履歴ボタンをaddSubViewする
    ///
    /// - isHistory == true: 履歴ボタンをaddSubViewする
    /// - isHistory == false: 履歴ボタンをremoveFromSuperviewする
    func historyButtonColorChange(){
        historyButton.isHidden = !isHistory
    }
    
}
