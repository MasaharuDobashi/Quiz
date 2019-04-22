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
    
    private let realm:Realm = try! Realm()
    private var quizManagementView:QuizManagementView?
    var quizModel:[QuizModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
        
        quizModelAppend()
        quizManagementView = QuizManagementView(frame: frame_Size(self), style: .grouped, quizModel: quizModel!)
        quizManagementView?.quizManagementViewDelegate = self
        self.view.addSubview(quizManagementView!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if quizModel!.count < realm.objects(QuizModel.self).count {
            quizModel?.append(realm.objects(QuizModel.self).last!)
            quizManagementView?.quizModel?.append(self.quizModel!.last!)
        }
        
        quizManagementView?.tableView?.reloadData()
    }
    
    
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
            self?.quizManagementView?.removeFromSuperview()
            
            self?.quizModel = nil
            self?.viewDidLoad()
            
            }, handler2: {_ -> Void in})
        
    }
    
    
    func deleteRealm(indexPath: IndexPath){
        let quizModel = realm.objects(QuizModel.self)[indexPath.row]
        
        
        try! realm.write() {
            realm.delete(quizModel)
        }
    }
}

