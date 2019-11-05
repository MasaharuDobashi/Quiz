//
//  QuizTypeManagementViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/11/03.
//  Copyright © 2019 m.dobashi. All rights reserved.
//


import UIKit
import RealmSwift

final class QuizTypeManagementViewController: UIViewController {
    
    var quizTypeModel: [QuizTypeModel]? {
        didSet {
            quizTypeManagementView.quizTypeModel = quizTypeModel
        }
    }
    private let config = Realm.Configuration(schemaVersion: realmConfig)
    private var realm:Realm!
    
    
    
    private lazy var quizTypeManagementView: QuizTypeManagementView = {
        let view: QuizTypeManagementView = QuizTypeManagementView(frame: frame_Size(self))
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm(configuration: config)
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
        view.addSubview(quizTypeManagementView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateQuizTypeUpdate), name: NSNotification.Name(rawValue: quizTypeUpdate), object: nil)
        quizModelAppend()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           
        
        debugPrint(object: quizTypeModel)
    }
    
    /// 配列にRealmで保存したデータを追加する
    private func quizModelAppend() {
        quizTypeModel = [QuizTypeModel]()
        
        let quizTypeModelCount:Int = realm.objects(QuizTypeModel.self).count
        for i in 0..<quizTypeModelCount {
            quizTypeModel?.append(realm.objects(QuizTypeModel.self)[i])
        }
    }
    
    
    ///
    @objc private func rightButtonAction() {
        let viewController:QuizTypeEditViewController = QuizTypeEditViewController()
        let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController,animated: true, completion: nil)
    }
    
    
    @objc func updateQuizTypeUpdate(notification: Notification) {
        quizTypeModel?.removeAll()
        quizModelAppend()
        viewWillAppear(false)
    }
    
}
