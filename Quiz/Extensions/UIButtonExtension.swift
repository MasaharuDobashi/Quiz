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
    func buttonHeight(multiplier: CGFloat, cornerRadius: CGFloat) {
        self.bounds.size.height = UIScreen.main.bounds.height * multiplier
        self.layer.cornerRadius = self.bounds.height / cornerRadius
    }
}
