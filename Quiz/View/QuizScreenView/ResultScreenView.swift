//
//  ResultScreenView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

protocol ResultScreenViewDelegate:class {
    var trueConunt:Int {get}
}

class ResultScreenView: UIView {
    private var trueConunt:String?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    
    convenience init(frame:CGRect, trueConunt:Int){
        self.init(frame: frame)
        self.trueConunt = String(trueConunt)
        
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewLoad(){
        self.backgroundColor = .white
        
        let correctView:UIView = UIView()

        guard let correctString:String = trueConunt else {
            return
        }
        
        let correctCountLabel:UILabel = UILabel()
        
        correctView.backgroundColor = .orange
        self.addSubview(correctView)
        
        correctCountLabel.text = "あなたは\(correctString)問正解しました。"
        correctView.addSubview(correctCountLabel)
        
        
        
        correctView.translatesAutoresizingMaskIntoConstraints = false
        correctView.topAnchor.constraint(equalTo: self.topAnchor, constant: 100).isActive = true
        correctView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        correctView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        correctView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        correctCountLabel.translatesAutoresizingMaskIntoConstraints = false
        correctCountLabel.topAnchor.constraint(equalTo: correctView.topAnchor).isActive = true
        correctCountLabel.leadingAnchor.constraint(equalTo: correctView.leadingAnchor, constant: 5).isActive = true
        correctCountLabel.trailingAnchor.constraint(equalTo: correctView.trailingAnchor, constant: -5).isActive = true
        correctCountLabel.heightAnchor.constraint(equalTo: correctView.heightAnchor).isActive = true
        
        
        /*
        UIView.animate(withDuration: 0.5, delay: 1, options: [.curveEaseIn], animations: {() -> Void in
            correctView.frame.origin.y += UIScreen.main.bounds.height / 2
        }, completion: nil)
        */

    }
}
