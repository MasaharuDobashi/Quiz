//
//  QuizCreateViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/26.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

/// Realmで登録したクイズの確認、編集、削除を行うためのViewController
final class QuizManagementViewController: UITableViewController, ManagementProtocol {
    
    // MARK: Properties
    
    /// Realmのスキームバージョンを設定
    var config = Realm.Configuration(schemaVersion: realmConfig)
    
    /// Realmのインスタンス
    var realm: Realm?
    
    /// クイズのリストを格納する
    private var quizModel:[QuizModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            realm = try Realm(configuration: Realm.Configuration(schemaVersion: realmConfig))
        } catch {
            AlertManager().alertAction(viewController: self, title: nil, message: "エラーが発生しました", handler: { _ in
                return
            })
            return
        }
        
        setUPTableView()
        setBarButtonItem()
        setNotificationCenter()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        modelAppend()
        debugPrint(object: quizModel)
    }
    
    
    
    
    /// TableView
    
    /// テーブルビューをセットする
    fileprivate func setUPTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.register(QuizListCell.self, forCellReuseIdentifier: "quizCell")
    }
    
    
    
    // MARK: Private Func
    
    /// 配列にRealmで保存したデータを追加する
    func modelAppend(){
        quizModel = [QuizModel]()
        
        
//        let quizModelCount:Int = realm.objects(QuizModel.self).count
        for model in (realm?.objects(QuizModel.self))! {
            quizModel?.append(model)
            
            quizModel?.sort {
                $0.id < $1.id
            }
            
        }
    }
    
    
    
    // MARK: Navigation Action
    
    /// クイズを作成するモーダルを表示
    override func rightButtonAction() {
        let viewController:QuizEditViewController = QuizEditViewController(mode: .add)
        let navigationController:UINavigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController,animated: true, completion: nil)
    }
    
    
    
    /// デバッグ用でデータベースを削除する
    @objc override func leftButtonAction(){
        
        AlertManager().alertAction(viewController: self,
                                   title: "データベースの削除",
                                   message: "作成した問題や履歴を全件削除します",
                                   handler1: { [weak self]  (action) in
                                    
                                    do {
                                        try self?.realm?.write {
                                            self?.realm?.deleteAll()
                                        }
                                    } catch {
                                        AlertManager().alertAction(viewController: self!, title: nil, message: "エラーが発生しました", handler: { _ in
                                            return
                                        })
                                        return
                                    }
                                    
                                    self?.modelAppend()
                                    self?.tabBarController?.selectedIndex = 0
                                    
                                    NotificationCenter.default.post(name: Notification.Name(AllDelete), object: nil)
        }){ (action) in return }
        
    }
    
    
    
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    /// 一つのセクションに表示する行数を設定
    ///
    /// - quizModelの件数が0件の場合: クイズが作成されていないことを表示するため１を返す
    /// - quizModelの件数を返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if quizModel?.count == 0 {
            return 1
        }
        return quizModel!.count
    }
    
    
    /// 表示するセルを設定する
    ///
    /// - quizModelの件数が0件の場合: クイズが作成されていないことを表示する
    /// - クイズのタイトルを表示する
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if quizModel?.count == 0 {
            /// "まだクイズが作成されていません"と表示する"
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = "まだクイズが作成されていません"
            cell.selectionStyle = .none
            return cell
        }
        
        /// モデルに格納されたクイズのタイトルを表示する
        let quizCell: QuizListCell = tableView.dequeueReusableCell(withIdentifier: "quizCell") as! QuizListCell
        quizCell.quizNoText = "問題\(indexPath.row + 1)"
        quizCell.quizTitleText = (quizModel?[indexPath.row].quizTitle)!
        quizCell.quizTypeText = quizModel?[indexPath.row].quizTypeModel?.quizTypeTitle
        quizCell.displaySwitch = (quizModel?[indexPath.row].displayFlag)
        
        return quizCell
    }
    
    
    
    /// 選択したクイズの詳細に遷移
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        detailAction(indexPath: indexPath)
    }
    
    
    
    /// クイズが0件の時はセルをえ選択させない
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if quizModel?.count == 0 {
            return nil
        }
        
        return indexPath
    }
    
    
    
    
    
    /// スワイプしたセルに「編集」「削除」の項目を表示する
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        /// 編集
        let edit = UITableViewRowAction(style: .normal, title: "編集") { [weak self]
            (action, indexPath) in
            
            self?.editAction(self!,
                             editViewController: QuizEditViewController(quzi_id: indexPath.row, mode: .edit)
            )
        }
        edit.backgroundColor = UIColor.orange
        
        
        /// 削除
        let del = UITableViewRowAction(style: .destructive, title: "削除") { [weak self]
            (action, indexPath) in
            
            self?.deleteAction(indexPath: indexPath)
        }
        
        return [edit, del]
    }
    
    
    /// クイズが0件の時はセルのスワイプをしない
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if quizModel?.count == 0 {
            return false
        }
        return true
    }
    
    
    
    
    
    
    
    // MARK: QuizManagementViewDelegate Func
    
    
    /// 指定したクイズの詳細を開く
    func detailAction(indexPath: IndexPath) {
        let viewController:QuizEditViewController = QuizEditViewController(quzi_id: indexPath.row, mode: ModeEnum.detail)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func editAction(_ tableViewController: UITableViewController, editViewController editVC: UIViewController) {
        let navigationController:UINavigationController = UINavigationController(rootViewController: editVC)
        tableViewController.present(navigationController,animated: true, completion: nil)
    }
    
    
    /// 指定したクイズを削除する
    private func deleteRealm(indexPath: IndexPath){
        guard let rquizModel = realm?.objects(QuizModel.self)[indexPath.row] else { return }
        
        
        
        do {
            try realm?.write() {
                realm?.delete(rquizModel)
            }
        } catch {
            AlertManager().alertAction(viewController: self, title: nil, message: "エラーが発生しました", handler: { _ in
                return
            })
            return
        }
        
    }
    
    
    
    /// 指定したクイズの削除
    func deleteAction(indexPath: IndexPath) {
        AlertManager().alertAction(viewController: self, title: nil, message: "削除しますか?", handler1: {[weak self] action in
            self?.deleteRealm(indexPath: indexPath)
            self?.quizModel?.removeAll()
            self?.modelAppend()
            
            }, handler2: {_ -> Void in})
        
        
    }
    
    
    
    
    
    // MARK: Other func
    
    
    func setNotificationCenter() {
        /// quizModelをアップデート
        NotificationCenter.default.addObserver(self, selector: #selector(quizUpdate(notification:)), name: NSNotification.Name(rawValue: QuizUpdate), object: nil)
        
        
        /// iOS13のモーダルを開きクイズを新規作成、編集をしてモーダルを閉じた時に
        /// viewWillAppearを呼び出す処理をセットする
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(callViewWillAppear(notification:)), name: NSNotification.Name(rawValue: ViewUpdate), object: nil)
        }
        
    }
    
    
    /// Debug時にデータベースのデータを削除用のボタンをセット
    func setBarButtonItem() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
        
        #if DEBUG
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(leftButtonAction))
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "allDelete"
        #endif
    }
    
    
    /// クイズを更新する
    @objc func quizUpdate(notification: Notification) {
        modelAppend()
    }
    
    
    /// Quizの作成、編集した後にテーブル更新の為にviewWillAppearを呼ぶ
    @objc @available(iOS 13.0, *)
    func callViewWillAppear(notification: Notification) {
        self.viewWillAppear(true)
    }
    
}

