//
//  QuizCreateView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/26.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit


// MARK: - QuizListCell

/// QuizManagementViewのテーブルに表示するセル
final class QuizListCell: UITableViewCell {
    
    // MARK: Properties
    
    /// クイズの問題ナンバーを表示する
    let quizNoLabel:UILabel = UILabel(title: nil,
                                      font: UIFont.systemFont(ofSize: 18),
                                      textColor: .black,
                                      backgroundColor: .clear,
                                      textAlignment: .left,
                                      numberOfLines: 1
    )
    
    /// クイズのタイトルを表示する
    let quizTitleLabel:UILabel = UILabel(title: nil,
                                         font: UIFont.systemFont(ofSize: 19),
                                         textColor: .black,
                                         backgroundColor: .clear,
                                         textAlignment: .left,
                                         numberOfLines: 0
    )
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = cellWhite
        textLabel?.font = UIFont.systemFont(ofSize: 18)
        textLabel?.backgroundColor = .clear
        textLabel?.textAlignment = .left
        textLabel?.numberOfLines = 1
        textLabel?.textColor = detailTextLabel?.textColor
        
        
        detailTextLabel?.font = UIFont.systemFont(ofSize: 19)
        detailTextLabel?.backgroundColor = .clear
        detailTextLabel?.textAlignment = .left
        detailTextLabel?.numberOfLines = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetCellValue
    
    
    func setCellValue(listValue: ListValue, displaySwitch: String){
        textLabel?.text = listValue.title
        textLabel?.accessibilityIdentifier = listValue.title
        
        detailTextLabel?.text = listValue.value
        if displaySwitch == "1" {
            self.backgroundColor = .lightGray
        }
    }
    
    
    /// セルを再利用するときはセルの背景色を白に戻す
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundColor = cellWhite
    }
    
}

