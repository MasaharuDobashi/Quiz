//
//  ResultScreenViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

class ResultScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButton))
        
        
        let frame:CGRect = CGRect(x: 0, y: (self.navigationController?.navigationBar.bounds.height)! +  UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - ((self.navigationController?.navigationBar.bounds.height)! +  UIApplication.shared.statusBarFrame.size.height))
        
        let resultScreenView:ResultScreenView = ResultScreenView(frame: frame)
        self.view.addSubview(resultScreenView)
    }
    
    
    
    @objc func leftButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
