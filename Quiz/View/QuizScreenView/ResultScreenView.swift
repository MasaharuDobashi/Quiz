//
//  ResultScreenView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

final class ResultScreenView: UIView {
    
    // MARK: Properties
    
    private var trueConunt:String?
    
    private var correctCountLabel: UILabel = {
        let label:UILabel = UILabel(title: "",
            font: UIFont.boldSystemFont(ofSize: 18),
            textColor: .white,
            backgroundColor: Rose,
            textAlignment: .left,
            numberOfLines: 0
        )
        label.labelHeight(height: 100, cornerRadius: 8)
        
        return label
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    
    convenience init(frame:CGRect, trueConunt:Int){
        self.init(frame: frame)
        self.trueConunt = String(trueConunt)
        
        backgroundColor = Beige
        
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewLoad
    
    private func viewLoad(){
        guard let correctString:String = trueConunt else {
            return
        }
        
        correctCountLabel.text = "   あなたは\(correctString)問正解しました"
        
        addSubview(correctCountLabel)
        
        correctCountLabel.translatesAutoresizingMaskIntoConstraints = false
        correctCountLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -100).isActive = true
        correctCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        correctCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        correctCountLabel.heightAnchor.constraint(equalToConstant: correctCountLabel.bounds.height).isActive = true
        correctCountLabel.layer.cornerRadius = correctCountLabel.bounds.height / 8
    }
    
    
    func animation(){
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: [.curveLinear], animations: {[weak self] in
            self?.correctCountLabel.frame.origin.y = 100
            }, completion: nil)
    }
}

