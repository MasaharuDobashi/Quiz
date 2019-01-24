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
        // Do any additional setup after loading the view, typically from a nib.
        
        let frame:CGRect = CGRect(x: 0, y: (self.navigationController?.navigationBar.bounds.height)! +  UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - ((self.navigationController?.navigationBar.bounds.height)! + (self.tabBarController?.tabBar.bounds.height)! + UIApplication.shared.statusBarFrame.size.height))
        
        let quizMainView:QuizMainView = QuizMainView(frame: frame)
        quizMainView.quizMainViewDelegate = self
        
        self.view.addSubview(quizMainView)
    }
    
    
    func quizStartButtonAction() {
        let viewContorller:QuizScreenViewController = QuizScreenViewController()
        //        self.navigationController?.pushViewController(viewContorller, animated: true)
        
        let navigationController:UINavigationController = UINavigationController(rootViewController: viewContorller)
        self.present(navigationController,animated: true, completion: nil)
    }
    
}

