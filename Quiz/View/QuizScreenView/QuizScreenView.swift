//
//  QuizScreenView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit


protocol QuizScreenViewDelagate:class {
    func buttonTapAction()
    func trueConut()
    var quizNum:Int {get}
    var trueConunt:Int {get}
}

class QuizScreenView: UIView {
    
    // MARK: Properties
    
    var quizModel:QuizModel!
    weak var quizScreenViewDelagate:QuizScreenViewDelagate?
    
    private var buttons:[UIButton]!
    private var quizScreenLabel:UILabel!
    
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    convenience init(frame:CGRect,  quizModel:QuizModel){
        self.init(frame: frame)
        self.quizModel = quizModel
        
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewLoad
    
    private func viewLoad(){

        self.backgroundColor = .white
         quizScreenLabel = UILabel(title: quizModel.quizTitle,
                                              font: UIFont.boldSystemFont(ofSize: 20),
                                              textColor: .white,
                                              backgroundColor: .gray,
                                              textAlignment: .center,
                                              numberOfLines: 0
        )
        quizScreenLabel.labelHeight(multiplier: 0.4, cornerRadius: 9)
        self.addSubview(quizScreenLabel)
        
        
        quizScreenLabel.translatesAutoresizingMaskIntoConstraints = false
        quizScreenLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        quizScreenLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        quizScreenLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        quizScreenLabel.heightAnchor.constraint(equalToConstant: quizScreenLabel.bounds.height).isActive = true
        
        
        let button1:UIButton = UIButton()
        let button2:UIButton = UIButton()
        let button3:UIButton = UIButton()
        let button4:UIButton = UIButton()
        self.addSubview(button1)
        self.addSubview(button2)
        self.addSubview(button3)
        self.addSubview(button4)
        
        buttons = [button1,button2,button3,button4]
        quizChange()
        
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 50).isActive = true
        button1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        button1.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -10).isActive = true
        button1.heightAnchor.constraint(equalToConstant: button1.bounds.height).isActive = true
        
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.topAnchor.constraint(equalTo: button1.topAnchor).isActive = true
        button2.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 10).isActive = true
        button2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        button2.heightAnchor.constraint(equalTo: button1.heightAnchor).isActive = true
        
        
        button3.translatesAutoresizingMaskIntoConstraints = false
        button3.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 30).isActive = true
        button3.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        button3.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -10).isActive = true
        button3.heightAnchor.constraint(equalTo: button1.heightAnchor).isActive = true
        
        
        button4.translatesAutoresizingMaskIntoConstraints = false
        button4.topAnchor.constraint(equalTo: button3.topAnchor).isActive = true
        button4.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 10).isActive = true
        button4.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        button4.heightAnchor.constraint(equalTo: button1.heightAnchor).isActive = true
        
    }
    
    // MARK: ButtonAction
    
    @objc private func buttonTapAction(sender:UIButton){
        if sender.titleLabel!.text == quizModel.trueAnswer {
            quizScreenViewDelagate?.trueConut()
        }
        quizScreenViewDelagate?.buttonTapAction()
    }
    
    // MARK: internalFunc
    
    func quizChange(){
        quizScreenLabel.text = quizModel.quizTitle
        
        var stringArray:[String] = [
            quizModel.trueAnswer,
            quizModel.falseAnswer1,
            quizModel.falseAnswer2,
            quizModel.falseAnswer3,
        ]
        
        var numbers = [0,1,2,3]
        let colors:[UIColor] = [.blue, .green, .orange, .magenta]
        
        for i in 0..<buttons.count {
            let num:Int = Int(arc4random_uniform(UInt32(numbers.count)))
            buttons[i].setButton(title: stringArray[num],
                                 backgroundColor: colors[i],
                                 font: UIFont.boldSystemFont(ofSize: 18),
                                 target: self,
                                 action: #selector(buttonTapAction)
            )
            
            buttons[i].buttonHeight(multiplier: 0.06, cornerRadius: 8)
            
            
            numbers.remove(at: num)
            stringArray.remove(at: num)
        }
    }
    
}
