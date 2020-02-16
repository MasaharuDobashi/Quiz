//
//  QuizScreenView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit


// MARK: - QuizScreenViewDelagate

protocol QuizScreenViewDelagate:class {
    func buttonTapAction()
    func trueConut()
}




// MARK: - QuizScreenView

class QuizScreenView: UIView {
    
    // MARK: Properties
    
    
    /// クイズを格納する配列
    var quizModel:QuizModel!
    
    /// デリゲート
    weak var delagate:QuizScreenViewDelagate?
    
    
    /// クイズの回答をするボタンを格納する配列
    private var buttons:[UIButton]!
    
    /// クイズのタイトルを表示するラベル
    private lazy var quizScreenLabel:UILabel = {
        let label: UILabel = UILabel(title: quizModel.quizTitle,
                                              font: UIFont.boldSystemFont(ofSize: 20),
                                              textColor: .white,
                                              backgroundColor:R.color.Rose,
                                              textAlignment: .center,
                                              numberOfLines: 0
        )
        label.labelHeight(multiplier: 0.4)
        
        return label
    }()
    
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    
    
    /// クイズの配列を格納するInit
    /// - Parameter frame: 本ビューのサイズ
    /// - Parameter model: クイズを格納する配列
    convenience init(frame:CGRect,  quizModel model:QuizModel){
        self.init(frame: frame)
        quizModel = model
        backgroundColor = R.color.Beige
        
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: ViewLoad
    
    private func viewLoad(){
        addSubview(quizScreenLabel)
        
        
        quizScreenLabel.translatesAutoresizingMaskIntoConstraints = false
        quizScreenLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        quizScreenLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        quizScreenLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        quizScreenLabel.heightAnchor.constraint(equalToConstant: quizScreenLabel.bounds.height).isActive = true
        
        /// 回答1
        let button1:UIButton = UIButton()
        
        /// 回答2
        let button2:UIButton = UIButton()
        
        /// 回答3
        let button3:UIButton = UIButton()
        
        /// 回答4
        let button4:UIButton = UIButton()

        
        buttons = [button1,button2,button3,button4]
        quizChange()
        
        
        /// 各回答ボタンに制約を付ける
        
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.topAnchor.constraint(equalTo: centerYAnchor, constant: 50).isActive = true
        button1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        button1.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10).isActive = true
        button1.heightAnchor.constraint(equalToConstant: button1.bounds.height).isActive = true
        
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.topAnchor.constraint(equalTo: button1.topAnchor).isActive = true
        button2.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10).isActive = true
        button2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        button2.heightAnchor.constraint(equalTo: button1.heightAnchor).isActive = true
        
        
        button3.translatesAutoresizingMaskIntoConstraints = false
        button3.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 30).isActive = true
        button3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        button3.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10).isActive = true
        button3.heightAnchor.constraint(equalTo: button1.heightAnchor).isActive = true
        
        
        button4.translatesAutoresizingMaskIntoConstraints = false
        button4.topAnchor.constraint(equalTo: button3.topAnchor).isActive = true
        button4.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10).isActive = true
        button4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        button4.heightAnchor.constraint(equalTo: button1.heightAnchor).isActive = true
        
    }
    
    
    
    
    // MARK: ButtonAction
    
    @objc private func buttonTapAction(sender:UIButton){
        if sender.titleLabel!.text == quizModel.trueAnswer {
            delagate?.trueConut()
        }
        delagate?.buttonTapAction()
    }
    
    
    
    
    // MARK: internalFunc
    
    
    /// クイズのタイトルラベルとボタンに回答をセットする
    func quizChange(){
        quizScreenLabel.text = quizModel.quizTitle
        
        var stringArray:[String] = [
            quizModel.trueAnswer,
            quizModel.falseAnswer1,
            quizModel.falseAnswer2,
            quizModel.falseAnswer3,
        ]
        
        for i in 0..<buttons.count {
            let num:Int = Int(arc4random_uniform(UInt32(stringArray.count)))
            buttons[i].setButton(title: stringArray[num],
                                 backgroundColor: R.color.Geranium,
                                 font: UIFont.boldSystemFont(ofSize: 18),
                                 target: self,
                                 action: #selector(buttonTapAction)
            )
            
            buttons[i].buttonHeight(multiplier: 0.06, cornerRadius: 8)
            buttons[i].highlightAction()
            
            stringArray.remove(at: num)
            
            
            addSubview(buttons[i])
        }
    }
    
}
