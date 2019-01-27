//
//  QuizScreenViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift


class QuizScreenViewController: UIViewController, QuizScreenViewDelagate {
    var quizScreenView:QuizScreenView?
    let realm:Realm = try! Realm()
    var num:Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        quizScreenView = QuizScreenView(frame: frame_Size(viewController: self), quizId: num!)
        quizScreenView?.quizScreenViewDelagate = self
        self.view.addSubview(quizScreenView!)
    }
    
    func buttonTapAction() {
        num? += 1
        if  num! < realm.objects(QuizModel.self).count {
            self.viewWillAppear(true)
        }else{
            let viewController:ResultScreenViewController = ResultScreenViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        
        
    }
    
}
