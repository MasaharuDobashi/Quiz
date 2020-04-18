//
//  QuizModel.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import Foundation
import RealmSwift

class QuizModel: Object {
    
    // MARK: Properties
    
    /// クイズのID
    @objc dynamic var id: String = ""
    
    /// クイズのタイトル
    @objc dynamic var quizTitle: String = ""
    
    /// クイズの正解
    @objc dynamic var trueAnswer: String = ""
    
    /// クイズの不正解1
    @objc dynamic var falseAnswer1: String = ""
    
    /// クイズの不正解2
    @objc dynamic var falseAnswer2: String = ""
    
    /// クイズの不正解3
    @objc dynamic var falseAnswer3: String = ""
    
    /// クイズの表示フラグ
    ///
    /// - 0: 表示
    /// - 1: 非表示
    @objc dynamic var displayFlag: String = ""
    
    /// クイズのカテゴリ
    @objc dynamic var quizTypeModel: QuizTypeModel?
    
    
    /// クイズの作成日時
    @objc dynamic var createTime:String?
    
    
    // createTimeをプライマリキーに設定
    override static func primaryKey() -> String? {
        return "createTime"
    }
    
    
    // MARK: Function
    
    /// クイズの全件検索
    class func allFindQuiz(_ vc: UIViewController, isSort: Bool) -> Results<QuizModel>? {
        guard let realm = RealmManager.initRealm(vc) else { return nil }
        
        if isSort {
            return realm.objects(QuizModel.self).sorted(byKeyPath: "id")
            
        }
        return realm.objects(QuizModel.self)
    }
    
    
    /// クイズの１件検索
    class func findQuiz(_ vc: UIViewController, quizid: String, createTime: String?) -> QuizModel? {
        guard let realm = RealmManager.initRealm(vc) else { return nil }
        
        if let _createTime = createTime {
            return (realm.objects(QuizModel.self).filter("createTime == '\(String(describing: _createTime))'").first)
        } else {
            return(realm.objects(QuizModel.self).filter("id == '\(String(describing: quizid))'").first!)
        }
    }
    
    
    
    /// ToDoを追加する
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - parameters: 登録するクイズのパラメータ
    class func addQuiz(_ vc: UIViewController, parameters: [String: Any]) {
        
        guard let realm = RealmManager.initRealm(vc) else { return }
        let quizModel: QuizModel = QuizModel()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ja_JP")
        let s_Date:String = formatter.string(from: Date())
        
        quizModel.id = String(realm.objects(QuizModel.self).count + 1)
        quizModel.quizTitle = parameters[ParameterKey().title] as! String
        quizModel.trueAnswer = parameters[ParameterKey().correctAnswer] as! String
        quizModel.falseAnswer1 = parameters[ParameterKey().incorrectAnswer1] as! String
        quizModel.falseAnswer2 = parameters[ParameterKey().incorrectAnswer2] as! String
        quizModel.falseAnswer3 = parameters[ParameterKey().incorrectAnswer3] as! String
        quizModel.displayFlag = parameters[ParameterKey().displayFlag] as! String
        
                
        let quiztype = realm.objects(QuizTypeModel.self).filter("id == '\( parameters[ParameterKey().quizType] as! String)'").first
        
        if let _quizTypeModel = quiztype {
            quizModel.quizTypeModel = _quizTypeModel
        }
        quizModel.createTime = s_Date
        
        do {
            try realm.write() {
                realm.add(quizModel)
            }
        }
        catch {
            AlertManager().alertAction(vc, message: R.string.error.errorMessage) { _ in
                                        return
            }
        }
    
    }
    
    
    
    /// クイズの更新
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - parameters: 更新するクイズのパラメーター
    ///   - id: 更新するクイズのID
    ///   - createTime: 更新するクイズの作成日
    class func updateQuiz(_ vc: UIViewController, parameters: [String: Any], id: String, createTime: String?) {
        guard let realm = RealmManager.initRealm(vc) else { return }
        
        
        let quiztype = realm.objects(QuizTypeModel.self).filter("id == '\( parameters[ParameterKey().quizType] as! String)'").first
            
        
        if let quizModel = QuizModel.findQuiz(vc, quizid: id, createTime: createTime) {
            do {
                try realm.write() {
                    quizModel.quizTitle = parameters[ParameterKey().title] as! String
                    quizModel.trueAnswer = parameters[ParameterKey().correctAnswer] as! String
                    quizModel.falseAnswer1 = parameters[ParameterKey().incorrectAnswer1] as! String
                    quizModel.falseAnswer2 = parameters[ParameterKey().incorrectAnswer2] as! String
                    quizModel.falseAnswer3 = parameters[ParameterKey().incorrectAnswer3] as! String
                    quizModel.displayFlag = parameters[ParameterKey().displayFlag] as! String
                    if let _quizTypeModel = quiztype {
                        quizModel.quizTypeModel = _quizTypeModel
                    }
                    
                    /// createTimeを追加する前のバージョンで作ったクイズの場合はcreateTimeを追加する
                    if quizModel.createTime!.isEmpty {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                        formatter.locale = Locale(identifier: "ja_JP")
                        let s_Date:String = formatter.string(from: Date())
                        
                        quizModel.createTime = s_Date
                    }
                    
                }
            } catch {
                AlertManager().alertAction(vc, title: nil, message: R.string.error.errorMessage, handler: { _ in
                    return
                })
                return
            }
            
        } else {
            AlertManager().alertAction(vc, title: nil, message: R.string.error.errorMessage, handler: { _ in
                return
            })
        }

    }
    
    
    /// クイズの削除
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - id: 削除するクイズのID
    ///   - createTime: 削除するクイズの作成日
    class func deleteQuiz(_ vc: UIViewController, id: String, createTime: String?) {
        guard let realm = RealmManager.initRealm(vc) else { return }
        if let quizModel = QuizModel.findQuiz(vc, quizid: id, createTime: createTime) {
            do {
                try realm.write() {
                    realm.delete(quizModel)
                }
            } catch {
                AlertManager().alertAction(vc, title: nil, message: R.string.error.errorMessage, handler: { _ in
                    return
                })
                return
            }
        }
        
    }
    
    
    
}

