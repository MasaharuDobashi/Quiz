//
//  HistoryModel.swift
//  Quiz
//
//  Created by 土橋正晴 on 2020/04/12.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import RealmSwift

class HistoryModel: Object {
    
    // MARK: Properties
    
    /// 正解数
    @objc dynamic var quizTrueCount: String = ""
    
    /// クイズの実施日時
    @objc dynamic var date: String = ""
    
    
    
    
    // MARK: Function
    
    
    /// 履歴の全件検索
    class func allFindHistory(_ vc: UIViewController) -> Results<HistoryModel>? {
        guard let realm = RealmManager.initRealm(vc) else { return nil }
        return realm.objects(HistoryModel.self).sorted(byKeyPath: "date")
    }
    
    
    
    /// クイズの結果を追加する
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - count: 正解数
    class func addHistory(_ vc: UIViewController, count: Int) {
        
        guard let realm = RealmManager.initRealm(vc) else { return }
        
        let historyModel = HistoryModel()
        historyModel.quizTrueCount = String(count)
        historyModel.date = String().nowDate_sec()
        
        
        #if DEBUG
            print("\nadd History Log Start -------------------------------------")
            print(historyModel)
            print("add History Log End     -------------------------------------")
        #endif
        
        do {
            try realm.write() {
                realm.add(historyModel)
            }
        } catch {
            AlertManager().alertAction(vc, title: nil, message: R.string.errors.errorMessage(), handler: { _ in
                return
            })
            return
        }
        
        if (realm.objects(HistoryModel.self).count) > 30 {
            deleteFirstHistory(vc, realm: realm)
        }
        
    
    }
    
    
    
    /// 履歴の先頭を削除する
    /// - Parameters:
    ///   - vc: 呼び出し元のVC
    ///   - realm: realmのインスタンス
    class func deleteFirstHistory(_ vc: UIViewController, realm: Realm){
        var historyModel:[HistoryModel] = [HistoryModel]()
        for i in 0..<realm.objects(HistoryModel.self).count {
            historyModel.append(realm.objects(HistoryModel.self)[i])
            
            historyModel.sort{
                $0.date < $1.date
            }
        }
        
                
        do {
            try realm.write() {
                realm.delete(historyModel.first!)
            }
        } catch {
            AlertManager().alertAction(vc, title: nil, message: R.string.errors.errorMessage(), handler: { _ in
                return
            })
            return
        }
        
        
    }
    
}








