//
//  QuizCategoryModelTests.swift
//  QuizTests
//
//  Created by 土橋正晴 on 2020/04/27.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import Quiz

class QuizCategoryModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        RealmManager().allDelete()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        RealmManager().allDelete()
    }


    /// カテゴリの追加
    func testAddCategoryModel() {
        QuizCategoryModel.addQuizCategoryModel(UIViewController(), categorytitle: "カテゴリ1")
        let quizCategoryModel = QuizCategoryModel.findQuizCategoryModel(UIViewController(), id: "1", createTime: nil)
        
        XCTAssertNotNil(quizCategoryModel?.id, "idが登録されていない")
        XCTAssert(quizCategoryModel?.quizTypeTitle == "カテゴリ1", "入力されたタイトルが登録されていない")
        XCTAssert(quizCategoryModel?.isSelect == "0", "選択状態になっている")
        XCTAssertNotNil(quizCategoryModel?.createTime, "createTimeが登録されていない")
    }
    
    
    /// カテゴリの更新
    func testUpdateCategoryModel() {
        QuizCategoryModel.addQuizCategoryModel(UIViewController(), categorytitle: "カテゴリ1")
        let quizCategoryModel = QuizCategoryModel.findQuizCategoryModel(UIViewController(), id: "1", createTime: nil)

        
        QuizCategoryModel.updateQuizCategoryModel(UIViewController(), id: quizCategoryModel!.id, createTime: quizCategoryModel?.createTime, categorytitle: "カテゴリ編集")
        XCTAssertNotNil(quizCategoryModel?.id == "1", "idが変わっている")
        XCTAssert(quizCategoryModel?.quizTypeTitle == "カテゴリ編集", "入力されたタイトルが編集されていない")
        XCTAssert(quizCategoryModel?.isSelect == "0", "選択状態になっている")
        XCTAssertNotNil(quizCategoryModel?.createTime, "createTimeが変わっている")
    }
    
    
    /// カテゴリの選択状態の更新
    func testUpdateSelect() {
        QuizCategoryModel.addQuizCategoryModel(UIViewController(), categorytitle: "カテゴリ1")
        let quizCategoryModel1 = QuizCategoryModel.findQuizCategoryModel(UIViewController(), id: "1", createTime: nil)
        
        sleep(1)
        QuizCategoryModel.addQuizCategoryModel(UIViewController(), categorytitle: "カテゴリ2")
        let quizCategoryModel2 = QuizCategoryModel.findQuizCategoryModel(UIViewController(), id: "2", createTime: nil)
        
        sleep(1)
        QuizCategoryModel.addQuizCategoryModel(UIViewController(), categorytitle: "カテゴリ3")
        let quizCategoryModel3 = QuizCategoryModel.findQuizCategoryModel(UIViewController(), id: "3", createTime: nil)
        
        QuizCategoryModel.updateisSelect(UIViewController(), selectCategory: quizCategoryModel1!)
        
        XCTAssert(quizCategoryModel1?.isSelect == "1", "選択状態になっていない")
        XCTAssert(quizCategoryModel2?.isSelect == "0", "選択状態になっている")
        XCTAssert(quizCategoryModel3?.isSelect == "0", "選択状態になっている")
        
        QuizCategoryModel.updateisSelect(UIViewController(), selectCategory: quizCategoryModel2!)
        
        XCTAssert(quizCategoryModel1?.isSelect == "0", "選択状態になっている")
        XCTAssert(quizCategoryModel2?.isSelect == "1", "選択状態になっていない")
        XCTAssert(quizCategoryModel3?.isSelect == "0", "選択状態になっている")
        
        
        QuizCategoryModel.updateisSelect(UIViewController(), selectCategory: quizCategoryModel3!)
        
        XCTAssert(quizCategoryModel1?.isSelect == "0", "選択状態になっている")
        XCTAssert(quizCategoryModel2?.isSelect == "0", "選択状態になっている")
        XCTAssert(quizCategoryModel3?.isSelect == "1", "選択状態になっていない")
    }
    
    
    
    /// カテゴリの削除テスト
    func testDeleteQuizCategory() {
        QuizCategoryModel.addQuizCategoryModel(UIViewController(), categorytitle: "カテゴリ1")
        let quizCategoryModel = QuizCategoryModel.findQuizCategoryModel(UIViewController(), id: "1", createTime: nil)
        
        quizCategoryModel?.deleteQuizCategoryModel(UIViewController(), id: quizCategoryModel!.id, createTime: (quizCategoryModel?.createTime)!) {
            XCTAssert(QuizCategoryModel.findAllQuizCategoryModel(UIViewController())?.count == 0, "削除されていない")
        }
        
    }
        
    

}
