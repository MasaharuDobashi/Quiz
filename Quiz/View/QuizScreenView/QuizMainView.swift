//
//  QuizMainView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

protocol QuizMainViewDelegate: class {
    func quizStartButtonAction(isCount: Bool)
}

class QuizMainView: UIView {
    
    private let realm:Realm = try! Realm()
    private var isCount:Bool = false
    weak var quizMainViewDelegate:QuizMainViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewLoad(){
        
        let button:UIButton = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("クイズスタート", for: .normal)
        button.buttonHeight(multiplier: 0.06, cornerRadius: 8)
        if realm.objects(QuizModel.self).count != 0 {
            button.backgroundColor = .orange
            isCount = true
        } else {
            button.backgroundColor = .gray
        }
        
        button.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
        self.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: button.bounds.height).isActive = true
        button.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    @objc private func buttonTapAction(){
        quizMainViewDelegate?.quizStartButtonAction(isCount: isCount)
    }
    
}
