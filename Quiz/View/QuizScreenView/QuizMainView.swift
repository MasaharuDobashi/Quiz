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
    func historyButtonAction()
}

class QuizMainView: UIView {
    
    // MARK: Properties
    private var quizStartButton:UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "quizStartButton"
        button.setButton(title: "",
                                  backgroundColor: .orange,
                                  font: UIFont.boldSystemFont(ofSize: 18),
                                  target: self, action: #selector(buttonTapAction)
        )
        button.buttonHeight(multiplier: 0.06, cornerRadius: 8)
        
        return button
    }()
    
    
    private lazy var historyButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "historyButton"
        button.setButton(title: "履歴",
                                backgroundColor: .blue,
                                font: UIFont.boldSystemFont(ofSize: 18),
                                target: self, action: #selector(historyButtonAction)
        )
        button.buttonHeight(multiplier: 0.06, cornerRadius: 8)
        
        return button
    }()
    
    var isActiveQuiz: Bool = false
    var isHistory: Bool? = false
    

    weak var quizMainViewDelegate:QuizMainViewDelegate?
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        backgroundColor = .white
        
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
        startButtonColorChange()
        addSubview(quizStartButton)
 
        setConstraint()
    }
    
    private func setConstraint(){
        quizStartButton.translatesAutoresizingMaskIntoConstraints = false
        quizStartButton.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -15).isActive = true
        quizStartButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        quizStartButton.heightAnchor.constraint(equalToConstant: quizStartButton.bounds.height).isActive = true
        quizStartButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
    }
    
    
    // MARK: ButtonAction
    @objc private func buttonTapAction(){
        quizMainViewDelegate?.quizStartButtonAction()
    }
    
    
    @objc private func historyButtonAction(){
        quizMainViewDelegate?.historyButtonAction()
    }
    
    // MARK: internalFunc
    
    func startButtonColorChange(){
        if isActiveQuiz == false {
            quizStartButton.setTitle("クイズを作成", for: .normal)
            quizStartButton.backgroundColor = .gray
        } else {
            quizStartButton.setTitle("クイズスタート", for: .normal)
            quizStartButton.backgroundColor = .orange
        }
    }
    
    func historyButtonColorChange(){
        if isHistory == true {
            addSubview(historyButton)
            
            historyButton.translatesAutoresizingMaskIntoConstraints = false
            historyButton.topAnchor.constraint(equalTo: centerYAnchor, constant: 15).isActive = true
            historyButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            historyButton.heightAnchor.constraint(equalToConstant: quizStartButton.bounds.height).isActive = true
            historyButton.widthAnchor.constraint(equalTo: quizStartButton.widthAnchor).isActive = true
        } else if isHistory == nil {
            historyButton.removeFromSuperview()
        }
    }
    
}
