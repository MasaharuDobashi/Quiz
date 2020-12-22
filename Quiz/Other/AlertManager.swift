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
    static func alertAction(_ viewController:UIViewController, title: String? = nil, message: String, didTapCloseButton: ((UIAlertAction) -> ())?){
        let controller:UIAlertController = UIAlertController(title: title,
                                                             message: message,
                                                             preferredStyle: .alert
        )
        
        controller.addAction(UIAlertAction(title: "閉じる",
                                           style: .default,
                                           handler: didTapCloseButton)
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
    static func alertAction(_ viewController:UIViewController, title: String? = nil, message: String, didTapDeleteButton: ((UIAlertAction) -> ())?,didTapCancelButton: ((UIAlertAction) -> ())?){
        let controller:UIAlertController = UIAlertController(title: title,
                                                             message: message,
                                                             preferredStyle: .alert
        )
        
        controller.addAction(UIAlertAction(title: "削除",
                                           style: .destructive,
                                           handler: didTapDeleteButton)
        )
        
        controller.addAction(UIAlertAction(title: "閉じる",
                                           style: .default,
                                           handler: didTapCancelButton)
        )
        viewController.present(controller, animated: true, completion: nil)
    }
    
    
    
    
    /// 「はい」「いいえ」ボタンが付いたアラート
    /// - Parameters:
    ///   - viewController: 呼び出し元のViewController
    ///   - title:タイトル
    ///   - message: メッセージ
    ///   - handler1: 「はい」ボタンのハンドラー
    static func alertAction(_ viewController:UIViewController, title: String?, message: String, didTapYesButton: ((UIAlertAction) -> ())?, didTapNoButton: ((UIAlertAction) -> ())?){
        let controller:UIAlertController = UIAlertController(title: title,
                                                             message: message,
                                                             preferredStyle: .alert
        )
        
        controller.addAction(UIAlertAction(title: "はい",
                                           style: .default,
                                           handler: didTapYesButton)
        )
        
        controller.addAction(UIAlertAction(title: "いいえ",
                                           style: .default,
                                           handler: didTapNoButton)
        )
        viewController.present(controller, animated: true, completion: nil)
    }
    
    
    
}
