//
//  QuizTypeManagementViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/11/03.
//  Copyright © 2019 m.dobashi. All rights reserved.
//


import UIKit
import RealmSwift


final class QuizTypeManagementViewController: UITableViewController {

    // MARK: Properties
    
    var config = Realm.Configuration(schemaVersion: realmConfig)
    
    var realm: Realm?
    
    
    var quizTypeModel: [QuizTypeModel]? {
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
        tableView.separatorInset = .zero
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateQuizTypeUpdate), name: NSNotification.Name(rawValue: quizTypeUpdate), object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        modelAppend()
        debugPrint(object: quizTypeModel)
        
    }
    
    
    
    
    
    /// 配列にRealmで保存したデータを追加する
    func modelAppend() {
        quizTypeModel = [QuizTypeModel]()
        
        let quizTypeModelCount:Int = (realm?.objects(QuizTypeModel.self).count)!
        for i in 0..<quizTypeModelCount {
            quizTypeModel?.append((realm?.objects(QuizTypeModel.self)[i])!)
        }
    }
    
    
    
    override func rightButtonAction() {
        presentModalView(QuizTypeEditViewController(typeid: nil, mode: .add))
    }
    
    
    @objc func updateQuizTypeUpdate(notification: Notification) {
        quizTypeModel?.removeAll()
        modelAppend()
    }
    

    
}















/// QuizTypeManagementViewControllerにManagementViewDelegateを拡張
extension QuizTypeManagementViewController: ManagementProtocol {
    
    func editAction(_ tableViewController: UITableViewController, editViewController editVC: UIViewController) {
        presentModalView(editVC)
    }
    
    
    
    
    func deleteAction(indexPath: IndexPath) {
        guard let rquizModel = realm?.objects(QuizTypeModel.self)[indexPath.row] else { return }
        
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
        
        NotificationCenter.default.post(name: Notification.Name(quizTypeUpdate), object: nil)
    }
    
    
    func detailAction(indexPath: IndexPath) {
        let viewController:QuizTypeEditViewController = QuizTypeEditViewController(typeid: quizTypeModel?[indexPath.row].id, mode: .detail)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    

}












///　QuizTypeManagementViewControllerにUITableViewDelegate, UITableViewDataSourceのメソッドを拡張
extension QuizTypeManagementViewController {
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if quizTypeModel?.count == 0 {
            return 1
        }
        
        return quizTypeModel!.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if quizTypeModel?.count == 0 {
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = "登録されていません"
            cell.selectionStyle = .none
            return cell
        }
        
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = quizTypeModel?[indexPath.row].quizTypeTitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        detailAction(indexPath: indexPath)
    }
    
    
    
    /// クイズが0件の時はセルを選択させない
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if quizTypeModel?.count == 0 {
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
                             editViewController: QuizTypeEditViewController(typeid: self?.quizTypeModel?[indexPath.row].id, mode: .edit
                )
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
        if quizTypeModel?.count == 0 {
            return false
        }
        return true
    }
    
}
