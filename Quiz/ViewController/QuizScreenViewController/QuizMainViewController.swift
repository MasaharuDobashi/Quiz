//
//  QuizMainViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

class QuizMainViewController: UIViewController, QuizMainViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let quizMainView:QuizMainView = QuizMainView(frame: frame_Size(viewController: self))
        quizMainView.quizMainViewDelegate = self
        
        self.view.addSubview(quizMainView)
    }
    
    
    func quizStartButtonAction(isCount: Bool) {
        if isCount {
            let viewController:QuizScreenViewController = QuizScreenViewController()
            let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController,animated: true, completion: nil)
        } else {
            let alert:UIAlertController = UIAlertController(title: "クイズを作成してください。", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil )
        }
    }
    
}

