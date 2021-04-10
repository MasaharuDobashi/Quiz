//
//  QuizCreateViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/26.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

/// Realmで登録したクイズの確認、編集、削除を行うためのViewController
final class QuizManagementViewController: UITableViewController {

    // MARK: Properties

    /// クイズのリストを格納する
    private var quizModel: [QuizModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUPTableView()
        setBarButtonItem()
        setNotificationCenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        modelAppend()
        debugPrint(object: quizModel)
    }

    // MARK: Private Func

    /// テーブルビューをセットする
    private func setUPTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = 5
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(R.nib.quizListCell)
    }

    // MARK: Navigation Action

    /// クイズを作成するモーダルを表示
    override func rightNaviBarButtonAction() {
        presentModalView(QuizEditViewController(mode: .add))
    }

    /// デバッグ用でデータベースを削除する
    @objc override func leftNaviBarButtonAction() {

        AlertManager().alertAction(self,
                                   title: R.string.messages.deleteDBTitle(),
                                   message: R.string.messages.deleteDBMessage(),
                                   didTapDeleteButton: { [weak self]  _ in
                                    guard let weakSelf = self else {
                                        return
                                    }
                                    RealmManager().allModelDelete(self!) {
                                        weakSelf.modelAppend()
                                        weakSelf.tabBarController?.selectedIndex = 0
                                        NotificationCenter.default.post(name: Notification.Name(R.string.notifications.allDelete()), object: nil)
                                    }
                                   }, didTapCancelButton: { _ in })

    }

    // MARK: Other func

    private func setNotificationCenter() {
        /// quizModelをアップデート
        NotificationCenter.default.addObserver(self, selector: #selector(quizUpdate(notification:)), name: NSNotification.Name(rawValue: R.string.notifications.quizUpdate()), object: nil)

    }

    /// クイズを更新する
    @objc func quizUpdate(notification: Notification) {
        modelAppend()
    }

}

/// UITableViewDelegate, UITableViewDataSourceの必須メソッド追加
extension QuizManagementViewController {

    // MARK: UITableViewDelegate, UITableViewDataSource

    /// 一つのセクションに表示する行数を設定
    ///
    /// - quizModelの件数が0件の場合: クイズが作成されていないことを表示するため１を返す
    /// - quizModelの件数を返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if quizModel.count == 0 {
            return 1
        }
        return quizModel.count
    }

    /// 表示するセルを設定する
    ///
    /// - quizModelの件数が0件の場合: クイズが作成されていないことを表示する
    /// - クイズのタイトルを表示する
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if quizModel.count == 0 {
            /// "まだクイズが作成されていません"と表示する"
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = "まだクイズが作成されていません"
            cell.selectionStyle = .none
            return cell
        }

        /// モデルに格納されたクイズのタイトルを表示する
        guard let quizCell = tableView.dequeueReusableCell(withIdentifier: R.nib.quizListCell.identifier) as?  QuizListCell else {
            return UITableViewCell()
        }
        quizCell.setValue(row: indexPath.row, model: quizModel[indexPath.row])
        return quizCell
    }

    /// 選択したクイズの詳細に遷移
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        detailAction(indexPath: indexPath)
    }

    /// クイズが0件の時はセルを選択させない
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if quizModel.count == 0 {
            return nil
        }

        return indexPath
    }

    /// スワイプしたセルに「編集」「削除」の項目を表示する
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        /// 編集
        let edit = UIContextualAction(style: .normal, title: R.string.button.edit()) { [weak self] _, _, _ in
            guard let weakSelf = self else {
                return
            }
            self?.editAction(weakSelf,
                             editViewController: QuizEditViewController(quzi_id: weakSelf.quizModel[indexPath.row].id,
                                                                        createTime: weakSelf.quizModel[indexPath.row].createTime,
                                                                        mode: .edit)
            )
        }
        edit.backgroundColor = UIColor.orange

        /// 削除
        let del = UIContextualAction(style: .destructive, title: R.string.button.delete()) { [weak self] _, _, _ in
            self?.deleteAction(indexPath: indexPath)
        }

        return UISwipeActionsConfiguration(actions: [edit, del])
    }

    /// クイズが0件の時はセルのスワイプをしない
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if quizModel.count == 0 {
            return false
        }
        return true
    }

}

/// ManagementProtocolを拡張
extension QuizManagementViewController: ManagementProtocol {

    // MARK: QuizManagementViewDelegate Func

    /// 配列にRealmで保存したデータを追加する
    func modelAppend() {
        quizModel = QuizModel.allFindQuiz(self, isSort: true) ?? []
    }

    /// 指定したクイズの詳細を開く
    func detailAction(indexPath: IndexPath) {
        pushTransition(QuizEditViewController(quzi_id: quizModel[indexPath.row].id,
                                              createTime: quizModel[indexPath.row].createTime,
                                              mode: ModeEnum.detail)
        )
    }

    /// 指定したクイズの編集画面を開く
    func editAction(_ tableViewController: UITableViewController, editViewController editVC: UIViewController) {
        presentModalView(editVC)
    }

    /// 指定したクイズの削除
    func deleteAction(indexPath: IndexPath) {
        AlertManager().alertAction(self, message: "削除しますか?", didTapDeleteButton: { [weak self] _ in
            guard let weakSelf = self else {
                return
            }
            QuizModel.deleteQuiz(weakSelf,
                                 id: weakSelf.quizModel[indexPath.row].id,
                                 createTime: weakSelf.quizModel[indexPath.row].createTime
            )
            weakSelf.modelAppend()

        }, didTapCancelButton: { _ in })

    }

}
