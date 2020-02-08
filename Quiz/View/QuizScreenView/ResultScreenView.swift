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
    
    /// ラベルに表示するテキスト
    private var trueCount: String? {
        /// セットされたらラベルにテキストをセットしてからラベルを表示する
        didSet {
            correctCountLabel.text = trueCount
            
            setConstraint()
            animation()
        }
    }
    
    
    /// ラベルに表示するテキストをセットする
    var correctString: String? {
        get {
            return trueCount!
        }
        
        set(str) {
            if let _str = str {
                trueCount = "   あなたは\(_str)問正解しました"
            } else {
                trueCount = "   あなたは0問正解しました"
            }
        }
    }
    
    /// 正解数を表示するラベル
    private var correctCountLabel: UILabel = {
        let label:UILabel = UILabel(title: "",
            font: UIFont.boldSystemFont(ofSize: 18),
            textColor: .white,
            backgroundColor:R.color.Rose,
            textAlignment: .left,
            numberOfLines: 0
        )
        label.labelHeight(height: 100, cornerRadius: 8)
        
        return label
    }()
    
    
    
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        backgroundColor = R.color.Beige
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: Animetion
    
    /// ラベルを上から表示するアニメーション
    func animation(){
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: [.curveLinear], animations: {[weak self] in
            self?.correctCountLabel.frame.origin.y = 100
            }, completion: nil)
    }
    
    
    // MARK: Constraint
    
    /// 制約をセットする
    func setConstraint() {
        addSubview(correctCountLabel)
        correctCountLabel.translatesAutoresizingMaskIntoConstraints = false
        correctCountLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -100).isActive = true
        correctCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        correctCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        correctCountLabel.heightAnchor.constraint(equalToConstant: correctCountLabel.bounds.height).isActive = true
        correctCountLabel.layer.cornerRadius = correctCountLabel.bounds.height / 8
    }
    
}

