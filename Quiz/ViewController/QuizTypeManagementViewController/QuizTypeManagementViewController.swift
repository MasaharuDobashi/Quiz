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
    
    var quizTypeModel: Results<QuizCategoryModel>? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateQuizTypeUpdate), name: NSNotification.Name(rawValue: R.notification.quizTypeUpdate), object: nil)
        
        setBarButtonItem()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        modelAppend()
        debugPrint(object: quizTypeModel)
        
    }
    
    
    
    /// テーブルビューをセットする
    private func setUPTableView() {
        tableView.separatorInset = .zero
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    
    
    
    override func rightButtonAction() {
        presentModalView(QuizTypeEditViewController(typeid: nil, mode: .add))
    }
    
    
    @objc func updateQuizTypeUpdate(notification: Notification) {
        modelAppend()
    }
    
    /// デバッグ用でデータベースを削除する
       @objc override func leftButtonAction(){
           
           AlertManager().alertAction(self,
                                      title: "データベースの削除",
                                      message: "作成した問題や履歴を全件削除します",
                                      handler1: { [weak self]  (action) in
                                       RealmManager().allModelDelete(self!) {
                                           self?.modelAppend()
                                           self?.tabBarController?.selectedIndex = 0
                                           NotificationCenter.default.post(name: Notification.Name(R.notification.AllDelete), object: nil)
                                       }
           }){ (action) in return }
           
       }
    
    
}















/// QuizTypeManagementViewControllerにManagementViewDelegateを拡張
extension QuizTypeManagementViewController: ManagementProtocol {
    
    
    /// 配列にRealmで保存したデータを追加する
    func modelAppend() {
        quizTypeModel = QuizCategoryModel.findAllQuizCategoryModel(self)
    }
    
    
    func editAction(_ tableViewController: UITableViewController, editViewController editVC: UIViewController) {
        presentModalView(editVC)
    }
    
    
    
    
    func deleteAction(indexPath: IndexPath) {
        
        QuizCategoryModel().deleteQuizCategoryModel(self, id: (quizTypeModel?[indexPath.row].id)!, createTime: (quizTypeModel?[indexPath.row].createTime)!) {
            
            NotificationCenter.default.post(name: Notification.Name(R.notification.quizTypeUpdate), object: nil)
        }
        

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
            cell.textLabel?.text = "まだカテゴリが作成されていません"
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
