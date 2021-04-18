//
//  RealmManager.swift
//  Quiz
//
//  Created by 土橋正晴 on 2020/04/13.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import RealmSwift

class RealmManager {

    /// Realmのインスタンス化
    static let realm: Realm? = {
        let realm: Realm
        do {
            realm = try Realm()
            return realm
        } catch {
            print("realm error: \(error)")
            return nil
        }
    }()

    /// Realmで保存したDB全件削除
    func allModelDelete(_ vc: UIViewController, completion: () -> Void) {
        let realm = RealmManager.realm

        do {
            try realm?.write {
                realm?.deleteAll()
            }
            completion()

        } catch {
            AlertManager().alertAction(vc,
                                       message: R.string.errors.errorMessage(),
                                       didTapCloseButton: nil)
            return
        }

    }

    /// Realmで保存したDB全件削除
    ///
    /// テスト時にしか使用しない
    func allDelete() {
        let realm = RealmManager.realm

        try? realm?.write {
            realm?.deleteAll()
        }

    }
}
