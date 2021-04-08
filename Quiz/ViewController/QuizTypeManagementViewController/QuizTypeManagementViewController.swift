//
//  QuizTypeManagementViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/11/03.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

final class QuizTypeManagementViewController: UITableViewController {

    // MARK: Properties

    var quizTypeModel: [QuizCategoryModel]? {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateQuizTypeUpdate), name: NSNotification.Name(rawValue: R.string.notifications.quizTypeUpdate()), object: nil)

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

    override func rightNaviBarButtonAction() {
        presentModalView(QuizTypeEditViewController(typeid: nil, createTime: nil, mode: .add))
    }

    @objc func updateQuizTypeUpdate(notification: Notification) {
        modelAppend()
    }

    /// デバッグ用でデータベースを削除する
    @objc override func leftNaviBarButtonAction() {

        AlertManager.alertAction(self,
                                 title: R.string.messages.deleteDBTitle(),
                                 message: R.string.messages.deleteDBMessage(),
                                 didTapDeleteButton: { [weak self]  _ in
                                    RealmManager().allModelDelete(self!) {
                                        self?.modelAppend()
                                        self?.tabBarController?.selectedIndex = 0
                                        NotificationCenter.default.post(name: Notification.Name(R.string.notifications.allDelete()), object: nil)
                                    }
                                 }) { _ in
        }

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

            NotificationCenter.default.post(name: Notification.Name(R.string.notifications.quizTypeUpdate()), object: nil)
        }

    }

    func detailAction(indexPath: IndexPath) {
        let viewController = QuizTypeEditViewController(typeid: quizTypeModel?[indexPath.row].id,
                                                        createTime: quizTypeModel?[indexPath.row].createTime,
                                                        mode: .detail
        )
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
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = "まだカテゴリが作成されていません"
            cell.selectionStyle = .none
            return cell
        }

        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
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
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        /// 編集
        let edit = UIContextualAction(style: .normal, title: "編集") { [weak self] _, _, _ in
            self?.editAction(self!,
                             editViewController: QuizTypeEditViewController(typeid: self?.quizTypeModel?[indexPath.row].id,
                                                                            createTime: self?.quizTypeModel?[indexPath.row].createTime,
                                                                            mode: .edit
                             )
            )
        }
        edit.backgroundColor = UIColor.orange

        /// 削除
        let del = UIContextualAction(style: .destructive, title: "削除") { [weak self] _, _, _ in
            self?.deleteAction(indexPath: indexPath)
        }

        return UISwipeActionsConfiguration(actions: [edit, del])
    }

    /// クイズが0件の時はセルのスワイプをしない
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if quizTypeModel?.count == 0 {
            return false
        }
        return true
    }

}
