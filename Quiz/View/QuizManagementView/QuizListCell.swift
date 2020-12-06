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
    private let quizNoLabel: UILabel = UILabel(title: nil,
                                      font: UIFont.systemFont(ofSize: 18),
                                      textColor: nil,
                                      backgroundColor: .clear,
                                      textAlignment: .left,
                                      numberOfLines: 1
    )
    
    /// クイズのタイトルを表示する
    private let quizTitleLabel: UILabel = UILabel(title: nil,
                                         font: UIFont.systemFont(ofSize: 19),
                                         textColor: nil,
                                         backgroundColor: .clear,
                                         textAlignment: .left,
                                         numberOfLines: 0
    )
    
    
    
    private let quizTypeLable: UILabel = {
        let label: UILabel = UILabel(title: nil,
                                            font: UIFont.systemFont(ofSize: 19),
                                            textColor: nil,
                                            backgroundColor: .clear,
                                            textAlignment: .left,
                                            numberOfLines: 0
        )
        label.isHidden = true
        
        return label
    }()
    
    
    /// No
    var quizNoText: String {
        get {
            quizNoLabel.sizeToFit()
            return quizNoLabel.text!
        }
        
        set(str) {
            quizNoLabel.text = str
        }
    }
    
    
    /// クイズのタイトル
    var quizTitleText: String {
        get {
            quizTitleLabel.sizeToFit()
            return quizTitleLabel.text!
        }
        
        set(str) {
            quizTitleLabel.text = str
        }
        
    }
    
    /// 問題のカテゴリ
    var quizTypeText: String? {
        get {
            quizTypeLable.sizeToFit()
            return quizTypeLable.text!
        }
        
        set(str) {
            if str != nil {
                quizTypeLable.text = str
                quizTypeLable.isHidden = false
            } else {
                quizTypeLable.text = ""
            }
        }
        
    }
    
    
    /// 表示・非表示のフラグでセルの色を変更
    var displaySwitch: String? {
        didSet {
            if displaySwitch == "1" {
                self.backgroundColor = .lightGray
            } else {
                self.backgroundColor = cellWhite
            }
        }
        
    }
    
    
    
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = cellWhite
        
        setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
    // MARK: Constraint
    
    /// 制約をセットする
    private func setConstraint() {
        
        contentView.addSubview(quizNoLabel)
        quizNoLabel.translatesAutoresizingMaskIntoConstraints = false
        quizNoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        quizNoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        quizNoLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        
        addSubview(quizTitleLabel)
        quizTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        quizTitleLabel.topAnchor.constraint(equalTo: quizNoLabel.topAnchor).isActive = true
        quizTitleLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 5).isActive = true
        quizTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        addSubview(quizTypeLable)
        quizTypeLable.translatesAutoresizingMaskIntoConstraints = false
        quizTypeLable.topAnchor.constraint(equalTo: quizTitleLabel.bottomAnchor, constant: 5).isActive = true
        quizTypeLable.leadingAnchor.constraint(equalTo: quizTitleLabel.leadingAnchor).isActive = true
        quizTypeLable.trailingAnchor.constraint(equalTo: quizTitleLabel.trailingAnchor).isActive = true
        quizTypeLable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
    
    
    
    
    // MARK: Reuse
    
    /// セルを再利用するときはセルの背景色を白に戻す
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundColor = cellWhite
    }
    
}

