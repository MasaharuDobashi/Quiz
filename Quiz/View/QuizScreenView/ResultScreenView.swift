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
    
    // MARK: Properties
    
    private var trueConunt:String?
    
    // MARK: Init
    
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
    
    // MARK: ViewLoad
    
    private func viewLoad(){
        self.backgroundColor = .white
        
        guard let correctString:String = trueConunt else {
            return
        }
        
        let correctCountLabel:UILabel = UILabel(title: "   あなたは\(correctString)問正解しました。",
            font: UIFont.systemFont(ofSize: 18),
            textColor: .black,
            backgroundColor: .orange,
            textAlignment: .left,
            numberOfLines: 0
        )
        correctCountLabel.labelHeight(height: 100, cornerRadius: 8)
        self.addSubview(correctCountLabel)
        
        correctCountLabel.translatesAutoresizingMaskIntoConstraints = false
        correctCountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 100).isActive = true
        correctCountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        correctCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        correctCountLabel.heightAnchor.constraint(equalToConstant: correctCountLabel.bounds.height).isActive = true
        correctCountLabel.layer.cornerRadius = correctCountLabel.bounds.height / 8
        
        
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: [.curveLinear], animations: {() -> Void in
            correctCountLabel.frame.origin.y += UIScreen.main.bounds.height / 2
            }) { _ in
                UIView.animate(withDuration: 3, delay: 3, options: [.curveLinear, .repeat, .autoreverse], animations: {() -> Void in
                    correctCountLabel.layoutIfNeeded()
                    correctCountLabel.bounds.size.height += 10
                    correctCountLabel.bounds.size.width += 10
                }, completion: nil)
            }
        
    }
}
