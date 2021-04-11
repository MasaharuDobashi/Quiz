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
            UIScreen.main.bounds
        }
    }

    @objc func setNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = leftNaviButton
        self.navigationItem.rightBarButtonItem = rightNaviButton
    }

    /// モーダルの時は「X」ボタンのを設定する
    ///
    /// プッシュ遷移の時には何も設定せず、「<戻る」が表示されるはず
    var leftNaviButton: UIBarButtonItem? {
        get {
            if isPresentModal {
                return UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftNaviBarButtonAction))
            }
            return nil
        }
    }

    /// 「+」NavigationButton
    var rightNaviButton: UIBarButtonItem {
        get {
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightNaviBarButtonAction))
        }
    }

    @objc func leftNaviBarButtonAction() {
        if isPresentModal {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func rightNaviBarButtonAction() {}

    /// モーダル遷移か判定
    private var isPresentModal: Bool {
        self.navigationController?.viewControllers.count ?? 0 <= 1
    }

    func debugPrint(object: Any?) {
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
            AlertManager().alertAction(viewController, title: nil, message: message, didTapCloseButton: { _ -> Void in })
            return false
        }
        return true
    }

    /// モーダル遷移
    /// - Parameter viewController: モーダル表示するViewController
    func presentModalView(_ viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }

    /// Push遷移
    /// - Parameter viewController: 遷移先のViewController
    func pushTransition(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    /// ナビゲーションバーに「+」ボタンとRealmModelの全件削除用のボタン(debug時)を追加する
    func setBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightNaviBarButtonAction))

        #if DEBUG
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(leftNaviBarButtonAction))
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "allDelete"
        #endif
    }

}
