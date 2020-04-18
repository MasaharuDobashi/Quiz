//
//  RealmManager.swift
//  Quiz
//
//  Created by 土橋正晴 on 2020/04/13.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    /// Realmのインスタンス化
    class func initRealm(_ vc: UIViewController) -> Realm? {
        
        let realm: Realm
        do {
            realm = try Realm()
            
            return realm
        }
        catch {
            AlertManager().alertAction(vc, message: "エラーが発生しました") { _ in
                                        return
            }
        }
        return nil
    }
    
    
    
    
    /// Realmで保存したDB全件削除
    func allModelDelete(_ vc: UIViewController, completion: () -> Void) {
        let realm = RealmManager.initRealm(vc)
        
        do {
            try realm?.write {
                realm?.deleteAll()
            }
            completion()
            
        } catch {
            AlertManager().alertAction(vc,
                                        message: R.string.error.errorMessage,
                                        handler: { _ in
                                            return
            })
            return
        }
        
    }
}
