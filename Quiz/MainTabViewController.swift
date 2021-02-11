//
//  MainTabViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewControllers = [UIViewController]()
        
        let quizMainViewController:QuizMainViewController = QuizMainViewController()
        let quizCreateViewController:QuizManagementViewController = QuizManagementViewController(style: .grouped)
        let quizTypeManagementViewController: QuizTypeManagementViewController = QuizTypeManagementViewController(style: .grouped)
        
        quizMainViewController.tabBarItem = UITabBarItem(title: "メイン", image: UIImage(systemName: "gamecontroller"), tag: 0)
        quizCreateViewController.tabBarItem = UITabBarItem(title: "クイズ", image: UIImage(systemName: "list.dash"), tag: 1)
        quizTypeManagementViewController.tabBarItem = UITabBarItem(title: "カテゴリ", image: UIImage(systemName: "list.dash"), tag: 2)
        
        viewControllers.append(quizMainViewController)
        viewControllers.append(quizCreateViewController)
        viewControllers.append(quizTypeManagementViewController)
        
        viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
        self.navigationController?.navigationBar.isTranslucent = true
        self.setViewControllers(viewControllers, animated: false)
        // Do any additional setup after loading the view.
    }
    
}
