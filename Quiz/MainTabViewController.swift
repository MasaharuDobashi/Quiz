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
        quizMainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        quizMainViewController.tabBarItem.title = "メイン"
        
        
        viewControllers.append(quizMainViewController)
        viewControllers = viewControllers.map{ UINavigationController(rootViewController: $0)}
        self.navigationController?.navigationBar.isTranslucent = true
        self.setViewControllers(viewControllers, animated: false)
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
