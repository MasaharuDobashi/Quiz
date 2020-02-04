//
//  UIViewControllerExtension.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/27.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


extension UIViewController {
    
    func frame_Size(_ viewController:UIViewController) -> CGRect {
        
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)//CGRect(x: 0, y: (viewController.navigationController?.navigationBar.bounds.height)! +  UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - ((viewController.navigationController?.navigationBar.bounds.height)! + UIApplication.shared.statusBarFrame.size.height))
    }
    
    
    
    
    @objc func navigationItemAction() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
    }
    
    
    
    @objc func leftButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func rightButtonAction() {}
    
    
    
    func debugPrint(object: Any?){
        #if DEBUG
        if let _object = object {
            print(_object)
        }
        #endif
    }
    
    
    
    /// 文字数が0以上かどうかバリデーションチェック
    ///
    /// - Parameters:
    ///   - title: チェックするテキスト
    ///   - message: エラー時のアラートメッセージ
    /// - Returns: バリデーションの結果
    func emptyValidate(viewController: UIViewController, title: String, message: String) -> Bool {
        if title.isEmpty {
            AlertManager().alertAction(viewController: viewController, title: nil, message: message, handler: {_ -> Void in})
            return false
        }
        return true
    }
    
    
    
    /// モーダル遷移
    /// - Parameter viewController: モーダル表示するViewController
    func presentModalView(_ viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController,animated: true, completion: nil)
    }
    
    
    /// Push遷移
    /// - Parameter viewController: 遷移先のViewController
    func pushTransition(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}





extension UIColor {
    class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    
    
    /// ダークモードかどうかで色を変更する
    /// - Parameter light: lightまたは、iOS13以前の端末で設定する色
    /// - Parameter dark: ダークモード時の色
    class func changeAppearnceColor(light: UIColor, dark: UIColor) -> UIColor {
        
        if #available(iOS 13.0, *) {
            
            let color: UIColor = UIColor() { traitCollection -> UIColor in
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
