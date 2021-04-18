//
//  QuizModel.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

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
    @objc dynamic var quizTypeModel: QuizCategoryModel?

    /// クイズの作成日時
    @objc dynamic var createTime: String?

    // createTimeをプライマリキーに設定
    override static func primaryKey() -> String? {
        "createTime"
    }

    // MARK: Function

    /// クイズの全件検索
    class func allFindQuiz(_ vc: UIViewController) -> [QuizModel] {
        guard let realm = RealmManager.realm else { return [] }
        var returnModel = [QuizModel]()
        let model: Results<QuizModel> = realm.objects(QuizModel.self)
        model.forEach { value in
            returnModel.append(value)
            returnModel.sort {
                $0.createTime ?? "" < $1.createTime ?? ""
            }
        }
        return returnModel
    }

    /// クイズの１件検索
    class func findQuiz(_ vc: UIViewController, quizid: String, createTime: String?) -> QuizModel? {
        guard let realm = RealmManager.realm else { return nil }

        if let _createTime = createTime {
            return (realm.objects(QuizModel.self).filter("createTime == '\(_createTime)'").first)
        } else {
            return(realm.objects(QuizModel.self).filter("id == '\(quizid)'").first)
        }
    }

    /// クイズの全件検索
    class func displayFindQuiz(_ vc: UIViewController) -> [QuizModel] {
        guard let realm = RealmManager.realm else { return [] }
        var model: [QuizModel] = [QuizModel]()
        let realmModel = (realm.objects(QuizModel.self).filter("displayFlag == '0'"))
        realmModel.forEach { model.append($0) }
        return model
    }

    /// 選択されているカテゴリのクイズを検索
    class func selectQuiz(_ vc: UIViewController) -> [QuizModel] {
        guard let realm = RealmManager.realm else { return [] }
        var model: [QuizModel] = [QuizModel]()
        let realmModel = (realm.objects(QuizModel.self).filter("quizTypeModel.isSelect == '1' AND displayFlag == '0'"))
        realmModel.forEach { model.append($0) }
        return model
    }

    /// ToDoを追加する
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - parameters: 登録するクイズのパラメータ
    class func addQuiz(_ vc: UIViewController, title: String, correctAnswer: String, incorrectAnswer1: String, incorrectAnswer2: String, incorrectAnswer3: String, displayFlag: String, quizType: String) {

        guard let realm = RealmManager.realm else { return }
        let quizModel = QuizModel()
        quizModel.id = String(realm.objects(QuizModel.self).count + 1)
        quizModel.quizTitle = title
        quizModel.trueAnswer = correctAnswer
        quizModel.falseAnswer1 = incorrectAnswer1
        quizModel.falseAnswer2 = incorrectAnswer2
        quizModel.falseAnswer3 = incorrectAnswer3
        quizModel.displayFlag = displayFlag

        if let _quizTypeModel = realm.objects(QuizCategoryModel.self).filter("id == '\(quizType)'").first {
            quizModel.quizTypeModel = _quizTypeModel
        }
        quizModel.createTime = Format().stringFromDate(date: Date(), addSec: true)

        do {
            try realm.write {
                realm.add(quizModel)
            }
        } catch {
            AlertManager().alertAction(vc, message: R.string.errors.errorMessage(), didTapCloseButton: nil)
        }

    }

    /// クイズの更新
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - parameters: 更新するクイズのパラメーター
    ///   - id: 更新するクイズのID
    ///   - createTime: 更新するクイズの作成日
    class func updateQuiz(_ vc: UIViewController, id: String, createTime: String?, title: String, correctAnswer: String, incorrectAnswer1: String, incorrectAnswer2: String, incorrectAnswer3: String, displayFlag: String, quizType: String) {
        guard let realm = RealmManager.realm else { return }

        if let quizModel = QuizModel.findQuiz(vc, quizid: id, createTime: createTime) {
            do {
                try realm.write {
                    quizModel.quizTitle = title
                    quizModel.trueAnswer = correctAnswer
                    quizModel.falseAnswer1 = incorrectAnswer1
                    quizModel.falseAnswer2 = incorrectAnswer2
                    quizModel.falseAnswer3 = incorrectAnswer3
                    quizModel.displayFlag = displayFlag
                    if let _quizTypeModel = realm.objects(QuizCategoryModel.self).filter("id == '\(quizType)'").first {
                        quizModel.quizTypeModel = _quizTypeModel
                    }

                    /// createTimeを追加する前のバージョンで作ったクイズの場合はcreateTimeを追加する
                    if let createTime: String = quizModel.createTime {
                        if createTime.isEmpty {
                            quizModel.createTime = Format().stringFromDate(date: Date(), addSec: true)
                        }
                    }

                }
            } catch {
                AlertManager().alertAction(vc, title: nil, message: R.string.errors.errorMessage(), didTapCloseButton: nil)
            }

        } else {
            AlertManager().alertAction(vc, title: nil, message: R.string.errors.errorMessage(), didTapCloseButton: nil)
        }

    }

    /// クイズの削除
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - id: 削除するクイズのID
    ///   - createTime: 削除するクイズの作成日
    class func deleteQuiz(_ vc: UIViewController, id: String, createTime: String?) {
        guard let realm = RealmManager.realm else { return }
        if let quizModel = QuizModel.findQuiz(vc, quizid: id, createTime: createTime) {
            do {
                try realm.write {
                    realm.delete(quizModel)
                }
            } catch {
                AlertManager().alertAction(vc, title: nil, message: R.string.errors.errorMessage(), didTapCloseButton: { _ in
                })
                return
            }
        }

    }

}
