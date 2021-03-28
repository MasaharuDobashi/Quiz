//
//  UILabelExtension.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/05/13.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

extension UILabel {
    
    public convenience init(title: String? = nil, font: UIFont? = nil, textColor: UIColor? = nil, backgroundColor: UIColor? = nil, textAlignment: NSTextAlignment? = nil, numberOfLines: Int? = nil) {
        self.init()
        
        if let _title = title {
            text = _title
        }
        
        if let _font = font {
            self.font = _font
        }
        
        if let _textColor = textColor {
            self.textColor = _textColor
        }
        
        if let _backgroundColor = backgroundColor {
            self.backgroundColor = _backgroundColor
        }
        
        if let _textAlignment = textAlignment {
            self.textAlignment = _textAlignment
        }
        
        if let _numberOfLines = numberOfLines {
            self.numberOfLines = _numberOfLines
        }
    }
    
    func labelHeight(multiplier: CGFloat, cornerRadius: CGFloat? = nil) {
        self.bounds.size.height = UIScreen.main.bounds.height * multiplier
        if let _cornerRadius = cornerRadius {
            self.layer.cornerRadius = self.bounds.height / _cornerRadius
            self.clipsToBounds = true
        }
    }
    
    func labelHeight(height: CGFloat, cornerRadius: CGFloat? = nil) {
        self.bounds.size.height = height
        if let _cornerRadius = cornerRadius {
            self.layer.cornerRadius = self.bounds.height / _cornerRadius
            self.clipsToBounds = true
        }
    }
}
