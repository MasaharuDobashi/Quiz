//
//  QuizMainViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

class QuizMainViewController: UIViewController, QuizMainViewDelegate {
    
    // MARK: Properties
    private let realm:Realm = try! Realm(configuration: Realm.Configuration(schemaVersion: 1))
    
    private lazy var quizMainView:QuizMainView = {
        let isActiveQuiz: Bool = realm.objects(QuizModel.self).count != 0 ? true : false
        let quizMainView: QuizMainView = QuizMainView(frame: frame_Size(self))
        quizMainView.quizMainViewDelegate = self
        
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
        // 削除ボタンをナビゲーションバーにセットする
        NotificationCenter.default.addObserver(self, selector: #selector(allDeleteFlag(notification:)), name: NSNotification.Name(rawValue: "allDelete"), object: nil)
        #endif
        
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(callViewWillAppear(notification:)), name: NSNotification.Name(rawValue: HistoryUpdate), object: nil)
        }
        
    }
    
    #if DEBUG
    @objc func allDeleteFlag(notification: Notification){
        quizMainView.isHistory = nil
        quizMainView.historyButtonColorChange()
    }
    #endif
    
    /// ResultScreenViewControllerのモーダルが閉じたらViewWillAppearを呼ぶ
    @objc @available(iOS 13.0, *)
    func callViewWillAppear(notification: Notification) {
        self.viewWillAppear(true)
    }
    
}

