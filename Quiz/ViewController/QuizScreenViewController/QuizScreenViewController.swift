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
    
    // MARK: Properties
    private var quizScreenView:QuizScreenView?
    private let realm:Realm = try! Realm()
    
    // MARK: QuizScreenViewDelagate Properties
    var num: Int = 0
    var trueConunt: Int = 0
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        quizScreenView = QuizScreenView(frame: frame_Size(self), quizId: num)
        quizScreenView?.quizScreenViewDelagate = self
        self.view.addSubview(quizScreenView!)
    }
    
    
    // MARK: QuizScreenViewDelagate Func
    func buttonTapAction() {
        num += 1
        if  num < realm.objects(QuizModel.self).count {
            self.viewWillAppear(true)
        }else{
            let viewController:ResultScreenViewController = ResultScreenViewController(trueConunt: trueConunt)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func trueConut(){
         trueConunt += 1
    }
    
}
