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
     var quizNum: Int = 0
     var trueConunt: Int = 0
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
        
        
        
        quizModelAppend()
        if quizModel.count == 0 {return}
        if quizModel.count > 10 {return}
        
        quizScreenView = QuizScreenView(frame: frame_Size(self), quizModel: quizModel[quizNum])
        quizScreenView?.quizScreenViewDelagate = self
        self.view.addSubview(quizScreenView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        isQuizActive()
        debugPrint(object: quizModel[quizNum])
        
        quizScreenView?.quizModel = quizModel[quizNum]
        quizScreenView?.quizChange()
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
    
    
    /// <#Description#>
    func isQuizActive() {
        if quizModel.count == 0 {
            self.view.backgroundColor = .white
            AlertManager().alertAction(viewController: self, title: nil, message: "利用可能なクイズがありませんでした。", handler: {_ in
                self.leftButtonAction()
            })
            return
        } else if quizModel.count > 10 {
            self.view.backgroundColor = .white
            AlertManager().alertAction(viewController: self, title: "利用可能なクイズが10問を超えています。", message: "編集からクイズを非表示または、削除をし１０問以下に減らして下さい。", handler: { _ in
                self.leftButtonAction()
            })
            return
        }
        
    }
    
    // MARK: QuizScreenViewDelagate Func
    func buttonTapAction() {
        quizNum += 1
        if  quizNum < quizModel.count {
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
