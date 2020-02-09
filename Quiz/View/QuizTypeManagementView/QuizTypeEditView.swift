//
//  QuizTypeEditView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/11/04.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

final class QuizTypeEditView: UIView {
    
    
    private var typeLabel: UILabel = {
        let label: UILabel = UILabel(title: "クイズのカテゴリ")
        label.sizeToFit()
        
        return label
    }()
    
    
    
    lazy var typeTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "クイズのカテゴリを入力してください"
        
        return textField
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewLoad()
    }
    
    
    
    
    /// edit,detail Init
    convenience init(frame: CGRect, mode:ModeEnum) {
        self.init(frame: frame)
        
        if mode == .detail {
            typeTextField.isEnabled = false
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func viewLoad() {
        addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100).isActive = true
        typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        typeLabel.widthAnchor.constraint(equalToConstant: typeLabel.bounds.width).isActive = true
        typeLabel.heightAnchor.constraint(equalToConstant: typeLabel.bounds.height).isActive = true
        
        addSubview(typeTextField)
        typeTextField.translatesAutoresizingMaskIntoConstraints = false
        typeTextField.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 0).isActive = true
        typeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        typeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        typeTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
        
    }
    
}
