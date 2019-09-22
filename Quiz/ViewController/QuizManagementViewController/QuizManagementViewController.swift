//
//  QuizCreateViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/26.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

class QuizManagementViewController: UIViewController, QuizManagementViewDelegate {
    
    // MARK: Properties
    private let config = Realm.Configuration(schemaVersion: 1)
    private var realm:Realm!
    private var quizModel:[QuizModel]?
    
    private lazy var quizManagementView:QuizManagementView = {
        let quizManagementView: QuizManagementView = QuizManagementView(frame: frame_Size(self), style: .grouped, quizModel: quizModel!)
        quizManagementView.quizManagementViewDelegate = self
        
       return quizManagementView
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
         realm = try! Realm(configuration: config)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
        
        setleftBarButtonItem()
        
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(callViewWillAppear(notification:)), name: NSNotification.Name(rawValue: QuizUpdate), object: nil)
        }
        
        
        quizModelAppend()
        view.addSubview(quizManagementView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if quizModel!.count < realm.objects(QuizModel.self).count {
            quizModel?.append(realm.objects(QuizModel.self).last!)
            quizManagementView.quizModel? = self.quizModel!
        }
        
        quizManagementView.reloadData()
        
        debugPrint(object: quizModel)
    }
    
    // MARK: Private Func
    
    /// 配列にRealmで保存したデータを追加する
    private func quizModelAppend(){
        quizModel = [QuizModel]()
        
        let quizModelCount:Int = realm.objects(QuizModel.self).count
        for i in 0..<quizModelCount {
            quizModel?.append(realm.objects(QuizModel.self)[i])
        }
    }
    
    
    
    // MARK: Navigation Action
    /// クイズを作成するモーダルを表示
    @objc private func rightButtonAction(){
        
        let viewController:QuizEditViewController = QuizEditViewController(mode: .add)
        let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController,animated: true, completion: nil)
    }
    
    
    
    /// デバッグ用でデータベースを削除する
    @objc override func leftButtonAction(){
        
        AlertManager().alertAction(viewController: self, title: "データベースの削除", message: "作成した問題や履歴を全件削除します", handler1: { [weak self]  (action) in
            try! self?.realm.write {
                self?.realm.deleteAll()
            }
            
            self?.tabBarController?.selectedIndex = 0
            self?.viewDidAppear(false)
            self?.viewDidLoad()
            NotificationCenter.default.post(name: Notification.Name("allDelete"), object: nil)
        }){ (action) in return }
        
    }
    
    
    // MARK: QuizManagementViewDelegate Func
    
    
    /// 指定したクイズの詳細を開く
     func detailAction(indexPath: IndexPath) {
         let viewController:QuizEditViewController = QuizEditViewController(quzi_id: indexPath.row, mode: ModeEnum.detail)
         self.navigationController?.pushViewController(viewController, animated: true)
     }
         
     
    /// 指定したクイズの編集画面を開く
    func editAction(indexPath: IndexPath) {
        let viewController:QuizEditViewController = QuizEditViewController(quzi_id: indexPath.row, mode: ModeEnum.edit)
        let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController,animated: true, completion: nil)
    }
    
    
    /// 指定したクイズを削除する
    private func deleteRealm(indexPath: IndexPath){
        let quizModel = realm.objects(QuizModel.self)[indexPath.row]
        
        
        try! realm.write() {
            realm.delete(quizModel)
        }
    }
    
    
 
    /// 指定したクイズの削除
    func deleteAction(indexPath: IndexPath) {
        AlertManager().alertAction(viewController: self, title: nil, message: "削除しますか?", handler1: {[weak self] action in
            self?.deleteRealm(indexPath: indexPath)
            self?.quizManagementView.removeFromSuperview()
            
            self?.quizModel = nil
            self?.viewDidLoad()
            
            }, handler2: {_ -> Void in})
        
    }
    
    
    
    // MARK: Other func 
    
    /// Debug時にデータベースのデータを削除用のボタンをセット
    func setleftBarButtonItem() {
        #if DEBUG
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(leftButtonAction))
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "allDelete"
        #endif
    }
    
    
    
    /// Quizの作成、編集した後にテーブル更新の為にviewWillAppearを呼ぶ
    @objc @available(iOS 13.0, *)
    func callViewWillAppear(notification: Notification) {
        self.viewWillAppear(true)
    }

}

