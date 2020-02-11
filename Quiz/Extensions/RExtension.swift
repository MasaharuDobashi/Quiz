//
//  RExtension.swift
//  Quiz
//
//  Created by 土橋正晴 on 2020/02/09.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit


extension R {
    // MARK: String
    
    #if os(iOS) || os(tvOS)
    struct string {
        
        struct error {
            static let errorMessage = "エラーが発生しました"
        }
        

      fileprivate init() {}
    }
    #endif
    
    
    
    // MARK: Color
    
    #if os(iOS) || os(tvOS)
    struct color {
        
        static let Dawnpink:UIColor = UIColor.changeAppearnceColor(light: UIColor.rgba(red: 208, green: 184, blue: 187, alpha: 1), dark: .darkGray)
        static let Geranium:UIColor = UIColor.changeAppearnceColor(light: UIColor.rgba(red: 218, green: 61, blue: 92, alpha: 1), dark: .darkGray)
        static let Rubyred:UIColor = UIColor.changeAppearnceColor(light: UIColor.rgba(red: 207, green: 53, blue: 93, alpha: 1), dark: .black)
        static let Beige: UIColor = UIColor.changeAppearnceColor(light: UIColor.rgba(red: 245, green: 245, blue: 220, alpha: 1), dark: .black)
        static let Rose:UIColor = UIColor.changeAppearnceColor(light: UIColor.rgba(red: 244, green: 80, blue: 109, alpha: 1), dark: .darkGray)
        static let cellWhite: UIColor = UIColor.changeAppearnceColor(light: .white, dark: .rgba(red: 25, green: 25, blue: 25, alpha: 25))
        

      fileprivate init() {}
    }
    #endif
    
    
    // MARK: Notification
    
    #if os(iOS) || os(tvOS)
    struct notification {
        
        /// QuizManagementViewControllerの更新
        static let QuizUpdate: String = "quizUpdate"

        /// データベース内のデータ全削除
        static let AllDelete: String = "allDelete"

        /// iOS13以降でモーダルを閉じた時にViewWillAppearを呼ぶ
        static let ViewUpdate: String = "viewUpdate"

        /// QuizTypeManagementViewControllerの更新
        static let quizTypeUpdate = "quizTypeUpdate"
        

      fileprivate init() {}
    }
    #endif
}
