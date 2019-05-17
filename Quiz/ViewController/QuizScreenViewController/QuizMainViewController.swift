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
    
    private var quizMainView:QuizMainView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let isActiveQuiz: Bool = realm.objects(QuizModel.self).count != 0 ? true : false
        quizMainView = QuizMainView(frame: frame_Size(self), isActiveQuiz: isActiveQuiz)
        quizMainView.quizMainViewDelegate = self
        
        self.view.addSubview(quizMainView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        quizMainView.isActiveQuiz = realm.objects(QuizModel.self).count != 0 ? true : false
        quizMainView.buttonColorChange()
        
    }
    
    
    // MARK: QuizMainViewDelegate
    func quizStartButtonAction() {
        if quizMainView.isActiveQuiz {
            let viewController:QuizScreenViewController = QuizScreenViewController()
            let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController,animated: true, completion: nil)
        } else {
            let viewController:QuizEditViewController = QuizEditViewController(mode: .add)
            let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController,animated: true, completion: nil)}
    }
}

