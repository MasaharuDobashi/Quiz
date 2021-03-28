//
//  UIViewControllerExtension.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/27.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var frame: CGRect {
        get {
            return UIScreen.main.bounds
        }
    }
    
    @objc func navigationItemAction() {
        self.navigationItem.leftBarButtonItem = leftNaviButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
    }
    
    
    var leftNaviButton: UIBarButtonItem? {
        get {
            if self.navigationController?.viewControllers.count ?? 0 <= 1 {
                return UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
            }
            return nil
        }
    }
    
    
    
    
    @objc func leftButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func rightButtonAction() {}
    
    
    
    func debugPrint(object: Any?){
        #if DEBUG
        if let _object = object {
            print("\nObject Log Start -------------------------------------")
            print(_object)
            print("Object Log end   -------------------------------------")
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
            AlertManager.alertAction(viewController, title: nil, message: message, didTapCloseButton: {_ -> Void in})
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
    
    
    
    /// ナビゲーションバーに「+」ボタンとRealmModelの全件削除用のボタン(debug時)を追加する
    func setBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
        
        #if DEBUG
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(leftButtonAction))
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "allDelete"
        #endif
    }
    
    
}

