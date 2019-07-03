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
        
        #if DEBUG
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(leftButtonAction))
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "allDelete"
        #endif
        
        
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
    private func quizModelAppend(){
        quizModel = [QuizModel]()
        
        let quizModelCount:Int = realm.objects(QuizModel.self).count
        for i in 0..<quizModelCount {
            quizModel?.append(realm.objects(QuizModel.self)[i])
        }
    }
    
    @objc private func rightButtonAction(){
        
        let viewController:QuizEditViewController = QuizEditViewController(mode: .add)
        let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController,animated: true, completion: nil)
    }
    
    @objc override func leftButtonAction(){
        
        
//        realm = try! Realm(configuration: config)
        
        AlertManager().alertAction(viewController: self, title: "データベースの削除", message: "作成した問題や履歴を全件削除します", handler1: { [weak self]  (action) in
            try! self?.realm.write {
                self?.realm.deleteAll()
            }
            //        viewWillAppear(false)
            self?.tabBarController?.selectedIndex = 0
            self?.viewDidAppear(false)
            self?.viewDidLoad()
            NotificationCenter.default.post(name: Notification.Name("allDelete"), object: nil)
        }){ (action) in return }
        
    }
    
    private func deleteRealm(indexPath: IndexPath){
        let quizModel = realm.objects(QuizModel.self)[indexPath.row]
        
        
        try! realm.write() {
            realm.delete(quizModel)
        }
    }
    
    // MARK: QuizManagementViewDelegate Func
    
    func detailAction(indexPath: IndexPath) {
        let viewController:QuizEditViewController = QuizEditViewController(quzi_id: indexPath.row, mode: ModeEnum.detail)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func editAction(indexPath: IndexPath) {
        let viewController:QuizEditViewController = QuizEditViewController(quzi_id: indexPath.row, mode: ModeEnum.edit)
        let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController,animated: true, completion: nil)
    }
    
    func deleteAction(indexPath: IndexPath) {
        AlertManager().alertAction(viewController: self, title: nil, message: "削除しますか?", handler1: {[weak self] action in
            self?.deleteRealm(indexPath: indexPath)
            self?.quizManagementView.removeFromSuperview()
            
            self?.quizModel = nil
            self?.viewDidLoad()
            
            }, handler2: {_ -> Void in})
        
    }

}

