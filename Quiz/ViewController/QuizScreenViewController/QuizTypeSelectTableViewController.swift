//
//  QuizTypeSelectTableViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/11/27.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

final class QuizTypeSelectTableViewController: UITableViewController {
    
    // MARK: Properties
    
    /// クイズのカテゴリを格納
    private var quizTypeModel: Results<QuizCategoryModel>?

    /// 選択されたクイズのカテゴリを格納
    var selectCategory: QuizCategoryModel?
    
    var firstCheck = false
    
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
        
        setUpModel()
        
        setUpTableView()
    }

    
    
    
    
    /// 選択したクイズを登録
    override func rightButtonAction() {
        
        QuizCategoryModel.updateisSelect(self, selectCategory: (self.selectCategory)!)
        
        AlertManager.alertAction(self, title: nil, message: "クイズを選択しました", didTapCloseButton: { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
            }
        )
    }
    
    
    
    
    /// tableViewをセットする
    fileprivate func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.allowsMultipleSelection = false
    }

    
    
    
    /// quizTypeModelに格納する
    fileprivate func setUpModel() {
        quizTypeModel = QuizCategoryModel.findAllQuizCategoryModel(self)
        selectCategory = QuizCategoryModel.findSelectQuizCategoryModel(self)
     }
    
    
    
}
















// MARK: - UITableViewDelegate, UITableViewDataSource


/// UITableViewDelegate, UITableViewDataSourceを拡張
extension QuizTypeSelectTableViewController {
    
    
    
    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizTypeModel!.count
    }


    /// セルの設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = quizTypeModel?[indexPath.row].quizTypeTitle
        cell.selectionStyle = .none

        if quizTypeModel?[indexPath.row].isSelect == "1" {
            cell.accessoryType = .checkmark
            cell.isSelected = true
        }
        
        return cell
    }
    

    /// 選択したせるにチェックマークを付ける
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if firstCheck == false {
            for i in 0..<quizTypeModel!.count {
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
                cell?.accessoryType = .none
            }
            firstCheck = true
        }
        
        /// すでにチェック付いていたらチェックを外す
        let selectCell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))
        selectCategory = quizTypeModel?[indexPath.row]
        selectCell?.accessoryType = .none
        selectCell?.isSelected = false
        cell?.accessoryType = .checkmark
    }
    
    
    /// チェックマークの選択解除
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .none
    }
    
    
}









