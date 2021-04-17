//
//  HistoryModel.swift
//  Quiz
//
//  Created by 土橋正晴 on 2020/04/12.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import RealmSwift

class HistoryModel: Object {

    // MARK: Properties

    /// 正解数
    @objc dynamic var quizTrueCount: String = ""

    /// クイズの実施日時
    @objc dynamic var date: String = ""

    // MARK: Function

    /// 履歴の全件検索
    class func allFindHistory(_ vc: UIViewController) -> [HistoryModel] {
        guard let realm = RealmManager.realm else { return [] }
        let results = realm.objects(HistoryModel.self).sorted(byKeyPath: "date")

        guard !results.isEmpty else {
            print("HistoryModelが0件")
            return []
        }

        var returnModel: [HistoryModel] = [HistoryModel]()
        results.forEach { returnModel.append($0) }

        return returnModel
    }

    /// クイズの結果を追加する
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - count: 正解数
    class func addHistory(_ vc: UIViewController, count: Int) {

        guard let realm = RealmManager.realm else { return }

        let historyModel = HistoryModel()
        historyModel.quizTrueCount = String(count)
        historyModel.date = Format().stringFromDate(date: Format().nowDateFormat(addSec: true))

        #if DEBUG
        print("\nadd History Log Start -------------------------------------")
        print(historyModel)
        print("add History Log End     -------------------------------------")
        #endif

        do {
            try realm.write {
                realm.add(historyModel)
            }
        } catch {
            AlertManager().alertAction(vc, title: nil, message: R.string.errors.errorMessage(), didTapCloseButton: nil)
        }

        /// 履歴の保存の最大件数を３０件、超えたら古いものから削除
        if (realm.objects(HistoryModel.self).count) > 30 {
            deleteFirstHistory(vc, realm: realm)
        }

    }

    /// 履歴の先頭を削除する
    /// - Parameters:
    ///   - vc: 呼び出し元のVC
    ///   - realm: realmのインスタンス
    private class func deleteFirstHistory(_ vc: UIViewController, realm: Realm) {
        var historyModel: [HistoryModel] = [HistoryModel]()
        realm.objects(HistoryModel.self).forEach { value in
            historyModel.append(value)
            historyModel.sort {
                $0.date < $1.date
            }
        }

        guard let historyModelFirst = historyModel.first else {
            AlertManager().alertAction(vc, title: nil, message: R.string.errors.errorMessage(), didTapCloseButton: nil)
            return
        }

        do {
            try realm.write {
                realm.delete(historyModelFirst)
            }
        } catch {
            AlertManager().alertAction(vc, title: nil, message: R.string.errors.errorMessage(), didTapCloseButton: nil)
            return
        }

    }

}
