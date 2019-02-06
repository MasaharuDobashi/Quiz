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
    // QuizScreenViewDelagate var
    var num: Int = 0
    var trueConunt: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        quizScreenView = QuizScreenView(frame: frame_Size(viewController: self), quizId: num)
        quizScreenView?.quizScreenViewDelagate = self
        self.view.addSubview(quizScreenView!)
    }
    
    
    // QuizScreenViewDelagate Func
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
    
    //
    @objc func leftButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
