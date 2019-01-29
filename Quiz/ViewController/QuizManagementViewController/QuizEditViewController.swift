//
//  quizEditViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/28.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

class QuizEditViewController: UIViewController {
    
    var quizEditView:QuizEditView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButton))

        quizEditView = QuizEditView(frame: frame_Size(viewController: self))
        self.view.addSubview(quizEditView!)
        
    }
    
    @objc func leftButton(){
        self.dismiss(animated: true, completion: nil)
    }

}
