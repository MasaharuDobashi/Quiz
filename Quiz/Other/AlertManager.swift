//
//  AlertView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/19.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit


struct AlertManager {
    
    /// 「閉じる」ボタンのみ付いたアラート
    /// - Parameters:
    ///   - viewController: 呼び出し元のViewController
    ///   - title:タイトル
    ///   - message: メッセージ
    ///   - handler: 「閉じる」ボタンのハンドラー
    func alertAction(viewController:UIViewController, title: String?, message: String, handler: @escaping (UIAlertAction) -> ()){
        let controller:UIAlertController = UIAlertController(title: title,
                                                             message: message,
                                                             preferredStyle: .alert
        )
        
        controller.addAction(UIAlertAction(title: "閉じる",
                                           style: .default,
                                           handler: handler)
        )
        viewController.present(controller, animated: true, completion: nil)
    }
    
    
    
    
    /// 「削除」「閉じる」ボタンが付いたアラート
    /// - Parameters:
    ///   - viewController: 呼び出し元のViewController
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - handler1: 「削除」ボタンのハンドラー
    ///   - handler2: 「閉じる」ボタンのハンドラー
    func alertAction(viewController:UIViewController, title: String?, message: String, handler1: @escaping (UIAlertAction)->(),handler2: @escaping (UIAlertAction) -> ()){
        let controller:UIAlertController = UIAlertController(title: title,
                                                             message: message,
                                                             preferredStyle: .alert
        )
        
        controller.addAction(UIAlertAction(title: "削除",
                                           style: .destructive,
                                           handler: handler1)
        )
        
        controller.addAction(UIAlertAction(title: "閉じる",
                                           style: .default,
                                           handler: handler2)
        )
        viewController.present(controller, animated: true, completion: nil)
    }
    
    
    
    
    /// 「はい」「いいえ」ボタンが付いたアラート
    /// - Parameters:
    ///   - viewController: 呼び出し元のViewController
    ///   - title:タイトル
    ///   - message: メッセージ
    ///   - handler1: 「はい」ボタンのハンドラー
    func alertAction(viewController:UIViewController, title: String?, message: String, handler1: @escaping (UIAlertAction)->()){
        let controller:UIAlertController = UIAlertController(title: title,
                                                             message: message,
                                                             preferredStyle: .alert
        )
        
        controller.addAction(UIAlertAction(title: "はい",
                                           style: .default,
                                           handler: handler1)
        )
        
        controller.addAction(UIAlertAction(title: "いいえ",
                                           style: .default,
                                           handler: nil)
        )
        viewController.present(controller, animated: true, completion: nil)
    }
    
    
    
}
