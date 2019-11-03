//
//  QuizCreateView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/26.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

// MARK: - QuizManagementViewDelegate

protocol QuizManagementViewDelegate: class {
    func editAction(indexPath:IndexPath)
    func deleteAction(indexPath:IndexPath)
    func detailAction(indexPath:IndexPath)
}

// MARK: - QuizManagementView


/// Realmで登録したクイズの確認、編集、削除を行うためのテーブルビュー
final class QuizManagementView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    /// クイズのリストを格納するモデル
    var quizModel:[QuizModel]?
    
    
    var quizCount: Int = 0 {
        didSet {
            reloadData()
        }
    }
    
    /// QuizManagementViewのデリゲート
    weak var quizManagementViewDelegate:QuizManagementViewDelegate?
    
    
    
    // MARK: Init
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        self.separatorInset = .zero
        self.register(QuizListCell.self, forCellReuseIdentifier: "quizCell")
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: UITableViewDelegate, UITableViewDataSource
    
    /// 一つのセクションに表示する行数を設定
    ///
    /// - quizModelの件数が0件の場合: クイズが作成されていないことを表示するため１を返す
    /// - quizModelの件数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if quizCount == 0 {
            return 1
        }
        return quizCount
    }
    
    
    /// 表示するセルを設定する
    ///
    /// - quizModelの件数が0件の場合: クイズが作成されていないことを表示する
    /// - クイズのタイトルを表示する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if quizCount == 0 {
            /// "まだクイズが作成されていません"と表示する"
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = "まだクイズが作成されていません"
            cell.selectionStyle = .none
            return cell
        }
        
        /// モデルに格納されたクイズのタイトルを表示する
        let quizCell:QuizListCell = tableView.dequeueReusableCell(withIdentifier: "quizCell") as! QuizListCell
        quizCell.setCellValue(listValue: .init(title: "問題\(indexPath.row + 1)", value: (quizModel?[indexPath.row].quizTitle)!),
                              displaySwitch: (quizModel?[indexPath.row].displayFlag)!
        )
        
        return quizCell
    }
    
    
    
    /// 選択したクイズの詳細に遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        quizManagementViewDelegate?.detailAction(indexPath: indexPath)
    }
    
    
    
    /// クイズが0件の時はセルをえ選択させない
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if quizCount == 0 {
            return nil
        }
        
        return indexPath
    }
    
    
    
    
    
    /// スワイプしたセルに「編集」「削除」の項目を表示する
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        /// 編集
        let edit = UITableViewRowAction(style: .normal, title: "編集") { [weak self]
            (action, indexPath) in
            
            self?.quizManagementViewDelegate?.editAction(indexPath: indexPath)
        }
        
        edit.backgroundColor = UIColor.orange
        
        
        /// 削除
        let del = UITableViewRowAction(style: .destructive, title: "削除") { [weak self]
         (action, indexPath) in
            
            self?.quizManagementViewDelegate?.deleteAction(indexPath: indexPath)
            
        }

        return [edit, del]
    }
    
    
    /// クイズが0件の時はセルのスワイプをしない
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if quizModel?.count == 0 {
            return false
        }
        return true
    }
    

}



// MARK: - QuizListCell

/// QuizManagementViewのテーブルに表示するセル
fileprivate final class QuizListCell:UITableViewCell {
    
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

