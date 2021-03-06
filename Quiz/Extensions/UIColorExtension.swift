//
//  UIColorExtension.swift
//  Quiz
//
//  Created by 土橋正晴 on 2020/02/05.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }

    /// ダークモードかどうかで色を変更する
    /// - Parameter light: lightまたは、iOS13以前の端末で設定する色
    /// - Parameter dark: ダークモード時の色
    class func changeAppearnceColor(light: UIColor, dark: UIColor) -> UIColor {

        if #available(iOS 13.0, *) {

            let color = UIColor { traitCollection -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .light:
                    return light
                case .dark:
                    return dark
                default:
                    return light
                }
            }
            return color

        } else {
            return light
        }

    }

}
