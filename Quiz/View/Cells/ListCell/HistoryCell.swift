//
//  HistoryCell.swift
//  Quiz
//
//  Created by 土橋正晴 on 2020/12/11.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import UIKit

final class HistoryCell: UITableViewCell {

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        backgroundColor = R.color.cellWhite()
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// セルのテキストをセットする
    /// - Parameters:
    ///   - date: 日付
    ///   - count: 正解数
    func setValue(date: String, count: String) {
        textLabel?.text = delete_sec(date)
        detailTextLabel?.text = count + "問"
    }

    /// 秒数の部分を削除する
    private func delete_sec(_ str: String) -> String {
        /// 履歴の時間を秒数までの保存に変更したが、表示するのは分までなので秒数を削って表示する
        if str.count == "yyyy/MM/dd HH:mm:ss".count {
            return String(str.prefix(str.count - 3))
        } else {
            return str
        }

    }
}
