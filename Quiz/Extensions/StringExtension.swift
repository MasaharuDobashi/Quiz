//
//  StringExtension.swift
//  Quiz
//
//  Created by 土橋正晴 on 2020/04/19.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation


extension String {
    /// 現在の時間を返す(分まで)
    func nowDate_min() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd hh:mm"
        let now = Date()
        return format.string(from: now)
    }
    
    
    /// 現在の時間を返す(秒まで)
    func nowDate_sec() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: Date())
    }
    
    
}
