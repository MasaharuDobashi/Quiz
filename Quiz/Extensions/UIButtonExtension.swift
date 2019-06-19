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
}
