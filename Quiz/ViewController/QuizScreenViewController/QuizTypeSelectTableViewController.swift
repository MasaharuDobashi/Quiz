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
    
    private var realm:Realm?
    
    private var quizTypeModel: [QuizTypeModel]?

    
    var checkID: QuizTypeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
        
        
        setUpModel()
        
        setUpTableView()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    
    
    
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
        
        /// すでにチェック付いていたらチェックを外す
        let id: Int = Int(checkID?.id ?? "0") ?? 0
        let selectCell = tableView.cellForRow(at: IndexPath(row: id, section: 0))
        selectCell?.accessoryType = .none
        selectCell?.isSelected = false
        
        
        cell?.accessoryType = .checkmark
        checkID = self.realm?.objects(QuizTypeModel.self).filter("id == '\(String(describing: indexPath.row))'").first
    }
    
    
    /// チェックマークの選択解除
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
    
    
    /// quizTypeModelに格納する
    fileprivate func setUpModel() {
         do {
             realm = try Realm(configuration: Realm.Configuration(schemaVersion: realmConfig))
         } catch {
             AlertManager().alertAction(viewController: self, title: nil, message: "エラーが発生しました", handler: { _ in
                 return
             })
             return
         }
         
         quizTypeModel = [QuizTypeModel]()
         
         for type in (realm?.objects(QuizTypeModel.self))! {
             quizTypeModel?.append(type)
         }
        
        if let filter = (self.realm?.objects(QuizTypeModel.self).filter("isSelect == '1'").first) {
            checkID = filter
        }
     }
    
    
    /// tableViewをセットする
    fileprivate func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.allowsMultipleSelection = false
    }
    
    
    
    
    /// 選択したクイズを登録
    override func rightButtonAction() {
        AlertManager().alertAction(viewController: self, title: nil, message: "クイズを選択しました", handler: { [weak self] _ in
            
            /// チャックマークのついたセルのIDを格納
            guard let id: String = self?.checkID?.id else { return }
            
            /// チェックマークのついたIDと同じIDのクイズタイプを格納
            guard let filter: QuizTypeModel = (self?.realm?.objects(QuizTypeModel.self).filter("id == '\(id)'").first) else { return }
            
            /// isSelectが"1"になっていたクイズタイプを格納
            let afilter: QuizTypeModel? = (self?.realm?.objects(QuizTypeModel.self).filter("isSelect == '1'").first)
            
            do {
                try self?.realm?.write() {
                    filter.isSelect = "1"
                    afilter?.isSelect = "0"
                }
                self?.navigationController?.popViewController(animated: true)
                
            } catch {
                AlertManager().alertAction(viewController: self!, title: nil, message: "エラーが発生しました", handler: { _ in
                    return
                })
                return
            }}
            
        )
    }
    
}
