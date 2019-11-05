//
//  Constant.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/07/08.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit


// MARK: - RealmConfig

/// Realmのスキームバージョン
let realmConfig: UInt64 = 2


// MARK: - COLORS


let Morganite:UIColor = UIColor.changeAppearnceColor(light: UIColor.rgba(red: 205, green: 192, blue: 199, alpha: 1), dark: .darkGray)
let Dawnpink:UIColor = UIColor.changeAppearnceColor(light: UIColor.rgba(red: 208, green: 184, blue: 187, alpha: 1), dark: .darkGray)
let Geranium:UIColor = UIColor.changeAppearnceColor(light: UIColor.rgba(red: 218, green: 61, blue: 92, alpha: 1), dark: .darkGray)
let Rubyred:UIColor = UIColor.changeAppearnceColor(light: UIColor.rgba(red: 207, green: 53, blue: 93, alpha: 1), dark: .black)
let Beige: UIColor = UIColor.changeAppearnceColor(light: UIColor.rgba(red: 245, green: 245, blue: 220, alpha: 1), dark: .black)
let Rose:UIColor = UIColor.changeAppearnceColor(light: UIColor.rgba(red: 244, green: 80, blue: 109, alpha: 1), dark: .darkGray)
let cellWhite: UIColor = UIColor.changeAppearnceColor(light: .white, dark: .rgba(red: 25, green: 25, blue: 25, alpha: 25))


// MARK: - STRINGS

/// QuizManagementViewControllerの更新
let QuizUpdate: String = "quizUpdate"

/// データベース内のデータ全削除
let AllDelete: String = "allDelete"

/// iOS13以降でモーダルを閉じた時にViewWillAppearを呼ぶ
let ViewUpdate: String = "viewUpdate"


let quizTypeUpdate = "quizTypeUpdate"
