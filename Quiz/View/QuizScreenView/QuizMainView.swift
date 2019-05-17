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
    private let quizStartButton:UIButton = UIButton()
    var isActiveQuiz: Bool = false
    

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
        
        quizStartButton.setButton(title: "",
                         backgroundColor: .orange,
                         font: UIFont.boldSystemFont(ofSize: 18),
                         target: self, action: #selector(buttonTapAction)
        )
        quizStartButton.buttonHeight(multiplier: 0.06, cornerRadius: 8)
        buttonColorChange()
        self.addSubview(quizStartButton)
        
        quizStartButton.translatesAutoresizingMaskIntoConstraints = false
        quizStartButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        quizStartButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        quizStartButton.heightAnchor.constraint(equalToConstant: quizStartButton.bounds.height).isActive = true
        quizStartButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    // MARK: ButtonAction
    @objc private func buttonTapAction(){
        quizMainViewDelegate?.quizStartButtonAction()
    }
    
    // MARK: internalFunc
    
    func buttonColorChange(){
        if isActiveQuiz == false {
            quizStartButton.setTitle("クイズを作成", for: .normal)
            quizStartButton.backgroundColor = .gray
        } else {
            quizStartButton.setTitle("クイズスタート", for: .normal)
            quizStartButton.backgroundColor = .orange
        }
    }
    
}
