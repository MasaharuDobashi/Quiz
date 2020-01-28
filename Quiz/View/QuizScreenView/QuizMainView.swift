//
//  QuizMainView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit


// MARK: - QuizMainViewDelegate


protocol QuizMainViewDelegate: class {
    func quizStartButtonAction()
    func historyButtonAction()
    func quizTypeButtonAction()
}


// MARK: - QuizMainView

final class QuizMainView: UIView {
    
    // MARK: Properties
    
    
    /// クイズスタートボタン
    ///
    /// - クイズがなければクイズ作成モーダルを表示する
    /// - クイズを開始する
    private(set) var quizStartButton:UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "quizStartButton"
        button.setButton(title: "",
                                  backgroundColor: Geranium,
                                  font: UIFont.boldSystemFont(ofSize: 18),
                                  target: self, action: #selector(quizStartButtonTapAction)
        )
        button.buttonHeight(multiplier: 0.06, cornerRadius: 8)
        
        return button
    }()
    
    
    /// 履歴ボタン
    private(set) lazy var historyButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "historyButton"
        button.setButton(title: "履歴",
                                backgroundColor: Rose,
                                font: UIFont.boldSystemFont(ofSize: 18),
                                target: self, action: #selector(historyButtonAction)
        )
        button.buttonHeight(multiplier: 0.06, cornerRadius: 8)
        
        return button
    }()
    
    
    /// クイズの種類
    private(set) var quizTypeButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "typeButton"
        button.setButton(title: "クイズの選択",
                         backgroundColor: Geranium,
                         font: UIFont.boldSystemFont(ofSize: 18),
                         target: self, action: #selector(quizTypeButtonAction)
        )
        button.buttonHeight(multiplier: 0.06, cornerRadius: 8)
        
        return button
    }()
    
    
    
    
    
    /// クイズがあるかないかのフラグ
    ///
    /// - true: クイズがあればquizStartButtonをクイズスタートにする
    /// - false: クイズがなければquizStartButtonをクイズ作成ボタンにする
    var isActiveQuiz: Bool = false {
        didSet {
            startButtonColorChange()
        }
    }
    
    
    /// 履歴があるかないかのフラグ
    ///
    /// true:  historyButtonを表示する
    /// nil:  historyButtonを非表示にする
    var isHistory: Bool = false {
        didSet {
            historyButtonColorChange()
        }
    }
    
    
    
    var isQuizType: Bool = false {
        didSet {
            typeButtonColorChange()
        }
    }
    
    /// デリゲート
    weak var delegate:QuizMainViewDelegate?
    
    
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        backgroundColor = Beige
        setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    // MARK: Constraint
    
    /// quizStartButtontに制約を付ける
    private func setConstraint(){
        addSubview(quizStartButton)
        quizStartButton.translatesAutoresizingMaskIntoConstraints = false
        quizStartButton.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -15).isActive = true
        quizStartButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        quizStartButton.heightAnchor.constraint(equalToConstant: quizStartButton.bounds.height).isActive = true
        quizStartButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        
        addSubview(quizTypeButton)
        quizTypeButton.translatesAutoresizingMaskIntoConstraints = false
        quizTypeButton.topAnchor.constraint(equalTo: quizStartButton.bottomAnchor, constant: 15).isActive = true
        quizTypeButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        quizTypeButton.heightAnchor.constraint(equalToConstant: quizStartButton.bounds.height).isActive = true
        quizTypeButton.widthAnchor.constraint(equalTo: quizStartButton.widthAnchor).isActive = true
    }
    
    
    
    // MARK: ButtonAction
    
    /// クイズスタートボタンのタップアクション
    @objc private func quizStartButtonTapAction(){
        delegate?.quizStartButtonAction()
    }
    
    /// 履歴ボタンのタップアクション
    @objc private func historyButtonAction(){
        delegate?.historyButtonAction()
    }
    
    
    @objc private func quizTypeButtonAction() {
        delegate?.quizTypeButtonAction()
    }
    
    
    
    // MARK: internalFunc
    
    /// クイズスタートボタンの色を変える
    func startButtonColorChange(){
        if isActiveQuiz == false {
            quizStartButton.setTitle("クイズを作成", for: .normal)
            quizStartButton.backgroundColor = Dawnpink
        } else {
            quizStartButton.setTitle("クイズスタート", for: .normal)
            quizStartButton.backgroundColor = Geranium
        }
    }
    
    
    /// 履歴ボタンをaddSubViewする
    ///
    /// isHistory == true: 履歴ボタンをaddSubViewする
    /// isHistory == false: 履歴ボタンをremoveFromSuperviewする
    func historyButtonColorChange(){
        if isHistory == true {
            addSubview(historyButton)
            
            historyButton.translatesAutoresizingMaskIntoConstraints = false
            historyButton.topAnchor.constraint(equalTo: quizTypeButton.bottomAnchor, constant: 15).isActive = true
            historyButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            historyButton.heightAnchor.constraint(equalToConstant: quizStartButton.bounds.height).isActive = true
            historyButton.widthAnchor.constraint(equalTo: quizStartButton.widthAnchor).isActive = true
        } else if isHistory == false {
            historyButton.removeFromSuperview()
        }
    }
    
    
    /// quizTypeButtonをaddSubViewする
    ///
    /// isQuizType == true: クイズの選択ボタンをaddSubViewする
    /// isQuizType == false: クイズの選択をremoveFromSuperviewする
    func typeButtonColorChange(){
        if isQuizType == true {
            quizTypeButton.setTitle("クイズの選択", for: .normal)
            quizTypeButton.backgroundColor = Dawnpink
        } else {
            quizTypeButton.setTitle("クイズの種類を作成", for: .normal)
            quizTypeButton.backgroundColor = Dawnpink
        }
    }
    
}
