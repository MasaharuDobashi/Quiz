//
//  QuizCreateViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/26.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

class QuizManagementViewController: UIViewController, QuizManagementViewDelegate {

    
    
    var quizCreateView:QuizManagementView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
        quizCreateView = QuizManagementView(frame: frame_Size(viewController: self))
        quizCreateView?.quizManagementViewDelegate = self
        self.view.addSubview(quizCreateView!)
    }
    
    
    
    
    @objc func rightButtonAction(){
        let viewController:QuizEditViewController = QuizEditViewController()
        let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController,animated: true, completion: nil)
    }
    
    
    func cellTapAction(indexPath: IndexPath) {
        let viewController:QuizEditViewController = QuizEditViewController(quzi_id: indexPath.row)
        let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController,animated: true, completion: nil)
    }
}
