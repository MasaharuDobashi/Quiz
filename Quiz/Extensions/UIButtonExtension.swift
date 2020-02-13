//
//  UIButtonExtension.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/05/02.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {
    
    
    func setButton(title: String, backgroundColor: UIColor, font: UIFont ,target: Any?, action: Selector?) {
        setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        titleLabel?.font = font
        
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
        
        
    func buttonHeight(multiplier: CGFloat, cornerRadius: CGFloat) {
        self.bounds.size.height = UIScreen.main.bounds.height * multiplier
        self.layer.cornerRadius = self.bounds.height / cornerRadius
        self.clipsToBounds = true
    }
    
    
    
    /// ボタンを押したとき、離したときの影のon,off
    func highlightAction() {
        addShadow()
        addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
    }
    
    /// ボタンに影をつける
    private func addShadow() {
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 1, height: 1)
        clipsToBounds = false
    }
    
    
    /// ボタンを押した時にボタンの影を消す
    @objc private func buttonPressed(_ button: UIButton) {
        button.layer.shadowOpacity = 0.0
    }
    
    
    /// ボタンを離したときにボタンの影を付ける
    @objc private func buttonReleased(_ button: UIButton) {
        button.layer.shadowOpacity = 0.4
    }
    
}
