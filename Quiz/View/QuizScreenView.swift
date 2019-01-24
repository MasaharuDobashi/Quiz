//
//  QuizScreenView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

protocol QuizScreenViewDelagate:class {
    func buttonTapAction()
    
}

class QuizScreenView: UIView {
    let realm:Realm = try! Realm()
    var quizModel:QuizModel = QuizModel()
    weak var quizScreenViewDelagate:QuizScreenViewDelagate?
    var quizId:Int?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    convenience init(frame:CGRect, quizId:Int){
        self.init(frame: frame)
        self.quizId = quizId
        
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewLoad(){
//                addRealm()
        var stringArray:[String] = [
            realm.objects(QuizModel.self)[quizId!].trueAnswer,
            realm.objects(QuizModel.self)[quizId!].falseAnswer1,
            realm.objects(QuizModel.self)[quizId!].falseAnswer2,
            realm.objects(QuizModel.self)[quizId!].falseAnswer3
        ]
        
        
        
        self.backgroundColor = .white
        let quizScreenLabel:UILabel = UILabel()
        let button1:UIButton = UIButton()
        let button2:UIButton = UIButton()
        let button3:UIButton = UIButton()
        let button4:UIButton = UIButton()
        
        
        quizScreenLabel.backgroundColor = .gray
        quizScreenLabel.numberOfLines = 0
        quizScreenLabel.text = realm.objects(QuizModel.self)[quizId!].quizTitle
        self.addSubview(quizScreenLabel)
        
        quizScreenLabel.translatesAutoresizingMaskIntoConstraints = false
        quizScreenLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        quizScreenLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        quizScreenLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        quizScreenLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        
        button1.backgroundColor = .blue
        button1.setTitle(realm.objects(QuizModel.self)[quizId!].trueAnswer, for: .normal)
        button2.backgroundColor = .green
        button2.setTitle(realm.objects(QuizModel.self)[quizId!].falseAnswer1, for: .normal)
        button3.backgroundColor = .orange
        button3.setTitle(realm.objects(QuizModel.self)[quizId!].falseAnswer2, for: .normal)
        button4.backgroundColor = UIColor.magenta
        button4.setTitle(realm.objects(QuizModel.self)[quizId!].falseAnswer3, for: .normal)
        
        
        let buttons:[UIButton] = [button1,button2,button3,button4]
        var numbers = [0,1,2,3]
        
        for i in 0..<buttons.count {
            let num:Int = Int(arc4random_uniform(UInt32(numbers.count)))
            
            buttons[i].setTitle(stringArray[num], for: .normal)
            buttons[i].addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
            self.addSubview(buttons[i])
            
            numbers.remove(at: num)
            stringArray.remove(at: num)
        }
        
        
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 50).isActive = true
        button1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        button1.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -10).isActive = true
        button1.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.topAnchor.constraint(equalTo: button1.topAnchor).isActive = true
        button2.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 10).isActive = true
        button2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        button2.heightAnchor.constraint(equalTo: button1.heightAnchor).isActive = true
        
        
        button3.translatesAutoresizingMaskIntoConstraints = false
        button3.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 30).isActive = true
        button3.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        button3.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -10).isActive = true
        button3.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        
        
        button4.translatesAutoresizingMaskIntoConstraints = false
        button4.topAnchor.constraint(equalTo: button3.topAnchor).isActive = true
        button4.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 10).isActive = true
        button4.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        button4.heightAnchor.constraint(equalTo: button1.heightAnchor).isActive = true
        
    }
    
    
    @objc private func buttonTapAction(){
        quizScreenViewDelagate?.buttonTapAction()
    }
    
    func addRealm(){
        
        
        quizModel.id = "0"
        quizModel.quizType = "test"
        quizModel.quizTitle = "テスト問題1"
        quizModel.falseAnswer2 = "0"
        quizModel.falseAnswer1 = "２"
        quizModel.trueAnswer = "1"
        quizModel.falseAnswer3 = "３"
        
        try! realm.write() {
            realm.add(quizModel)
        }
    }
    
    
}
