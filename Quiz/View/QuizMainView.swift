//
//  QuizMainView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

protocol QuizMainViewDelegate: class {
    func quizStartButtonAction()
}

class QuizMainView: UIView {
    
    var quizMainViewDelegate:QuizMainViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewLoad(){
        self.backgroundColor = .white
        
        let button:UIButton = UIButton()
        button.setTitle("クイズスタート", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
        self.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    @objc func buttonTapAction(){
        quizMainViewDelegate?.quizStartButtonAction()
    }
    
}
