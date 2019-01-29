//
//  QuizCreateViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/26.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

class QuizManagementViewController: UIViewController {
    
    var quizCreateView:QuizManagementView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
        quizCreateView = QuizManagementView(frame: frame_Size(viewController: self))
        self.view.addSubview(quizCreateView!)
        
    }
    
    
    
    
    
    @objc func rightButtonAction(){
        let viewController:QuizEditViewController = QuizEditViewController()
        let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController,animated: true, completion: nil)
    }
}
