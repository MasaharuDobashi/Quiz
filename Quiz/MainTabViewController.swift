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
        let quizCreateViewController:QuizManagementViewController = QuizManagementViewController()
        let quizTypeManagementViewController: QuizTypeManagementViewController = QuizTypeManagementViewController()
        
        quizMainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        quizCreateViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 1)
        quizTypeManagementViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
//        quizMainViewController.tabBarItem.title = "メイン"
//        quizCreateViewController.tabBarItem.title = "管理"
        
        viewControllers.append(quizMainViewController)
        viewControllers.append(quizCreateViewController)
        viewControllers.append(quizTypeManagementViewController)
        
        viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
        self.navigationController?.navigationBar.isTranslucent = true
        self.setViewControllers(viewControllers, animated: false)
        // Do any additional setup after loading the view.
    }
    
}
