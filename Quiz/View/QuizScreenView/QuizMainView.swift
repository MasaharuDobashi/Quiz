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
    
    // MARK: Properties
    var isActiveQuiz: Bool!
    

    weak var quizMainViewDelegate:QuizMainViewDelegate?
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        
    }
    
    convenience init(frame: CGRect, isActiveQuiz: Bool) {
        self.init(frame:frame)
        self.isActiveQuiz = isActiveQuiz
        viewLoad()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewLoad
    
    private func viewLoad(){
        
        let button:UIButton = UIButton()
        button.setButton(title: "クイズスタート",
                         backgroundColor: .orange,
                         font: UIFont.boldSystemFont(ofSize: 18),
                         target: self, action: #selector(buttonTapAction)
        )
        button.buttonHeight(multiplier: 0.06, cornerRadius: 8)
        if isActiveQuiz == false { button.backgroundColor = .gray }
        self.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: button.bounds.height).isActive = true
        button.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    // MARK: ButtonAction
    @objc private func buttonTapAction(){
        quizMainViewDelegate?.quizStartButtonAction()
    }
    
}
