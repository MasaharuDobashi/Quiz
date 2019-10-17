//
//  QuizMainViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift


// MARK: - QuizMainViewController


class QuizMainViewController: UIViewController, QuizMainViewDelegate {
    
    // MARK: Properties
    
    /// Realmのスキームバージョンを設定
    private let realm:Realm = try! Realm(configuration: Realm.Configuration(schemaVersion: realmConfig))
    
    
    /// スタートボタンや履歴ボタンを表示する画面
    private lazy var quizMainView:QuizMainView = {
        let isActiveQuiz: Bool = realm.objects(QuizModel.self).count != 0 ? true : false
        let quizMainView: QuizMainView = QuizMainView(frame: frame_Size(self))
        quizMainView.delegate = self
        
        return quizMainView
    }()
    
    
    
    // MARK: Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNotificationCenter()
        
        view.addSubview(quizMainView)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        quizMainView.isActiveQuiz = realm.objects(QuizModel.self).count != 0 ? true : false
        quizMainView.startButtonColorChange()
        
        quizMainView.isHistory = realm.objects(HistoryModel.self).count != 0 ? true : false
        quizMainView.historyButtonColorChange()
        
    }
    
    
    // MARK: QuizMainViewDelegate
    
    
    /// クイズがあればクイズをスタートする、なければクイズの作成モーダルを表示する
    func quizStartButtonAction() {
        if quizMainView.isActiveQuiz {
            let viewController:QuizScreenViewController = QuizScreenViewController()
            let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
            present(navigationController,animated: true, completion: nil)
        } else {
            let viewController:QuizEditViewController = QuizEditViewController(mode: .add)
            let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
            present(navigationController,animated: true, completion: nil)}
    }
    
    
    
    /// 履歴画面を開く
    func historyButtonAction() {
        let viewController:HistoryViewController = HistoryViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    
    /// addObserverをセットする
    func setNotificationCenter() {
        #if DEBUG
        /// QuizManagementViewControllerでallDeleteがpostされたら履歴ボタンを更新する
        NotificationCenter.default.addObserver(self, selector: #selector(allDeleteFlag(notification:)), name: NSNotification.Name(rawValue: AllDelete), object: nil)
        #endif
        
        
        if #available(iOS 13.0, *) {
            /// iOS13以降のモーダルを閉じた時にHistoryUpdateがpostされたらViewWillAppearを呼ぶ
            NotificationCenter.default.addObserver(self, selector: #selector(callViewWillAppear(notification:)), name: NSNotification.Name(rawValue: HistoryUpdate), object: nil)
            
            /// iOS13以降のモーダルを閉じた時にHistoryUpdateがpostされたらViewWillAppearを呼ぶ
            NotificationCenter.default.addObserver(self, selector: #selector(callViewWillAppear(notification:)), name: NSNotification.Name(rawValue: QuizUpdate), object: nil)
        }
        
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
    
    
    
    /// ResultScreenViewControllerのモーダルが閉じたらViewWillAppearを呼ぶ
    @objc @available(iOS 13.0, *)
    func callViewWillAppear(notification: Notification) {
        self.viewWillAppear(true)
    }
    
}

