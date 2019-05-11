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
    private var quizModel:[QuizModel]!
    
    // MARK: QuizScreenViewDelagate Properties
    var num: Int = 0
    var trueConunt: Int = 0
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizModelAppend()
    
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if quizModel.count == 0 {
            self.view.backgroundColor = .white
            AlertManager().alertAction(viewController: self, title: nil, message: "利用可能なクイズがありませんでした。", handler: {_ in
                self.leftButtonAction()
            })
            
            return
        }
        
        quizScreenView = QuizScreenView(frame: frame_Size(self), quizModel: quizModel[num])
        quizScreenView?.quizScreenViewDelagate = self
        self.view.addSubview(quizScreenView!)
    }
    
    
    // MARK: Private Func
    
    private func quizModelAppend(){
        quizModel = [QuizModel]()
        
        let quizModelCount:Int = realm.objects(QuizModel.self).count
        for i in 0..<quizModelCount {
            if realm.objects(QuizModel.self)[i].displayFlag != "1" {
                quizModel?.append(realm.objects(QuizModel.self)[i])
            }
        }
        
    }
    
    // MARK: QuizScreenViewDelagate Func
    func buttonTapAction() {
        num += 1
        if  num < quizModel.count {
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
