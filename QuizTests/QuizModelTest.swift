//
//  QuizModelTest.swift
//  QuizTests
//
//  Created by 土橋正晴 on 2020/04/19.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import Quiz

class QuizModelTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

        RealmManager().allDelete()
    }

    /// クイズの追加tテスト
    func test_addQuizModelTest() {

        QuizModel.addQuiz(UIViewController(), title: "UnitTest",
                          correctAnswer: "correctAnswer",
                          incorrectAnswer1: "incorrectAnswer1",
                          incorrectAnswer2: "incorrectAnswer2",
                          incorrectAnswer3: "incorrectAnswer3",
                          displayFlag: "0",
                          quizType: ""
        )

        let quizModel = QuizModel.findQuiz(UIViewController(), quizid: "1", createTime: nil)

        XCTAssert(quizModel?.quizTitle == "UnitTest", "タイトルが違う")
        XCTAssert(quizModel?.trueAnswer == "correctAnswer", "正解が違う")
        XCTAssert(quizModel?.falseAnswer1 == "incorrectAnswer1", "不正解1が違う")
        XCTAssert(quizModel?.falseAnswer2 == "incorrectAnswer2", "不正解3が違う")
        XCTAssert(quizModel?.falseAnswer3 == "incorrectAnswer3", "不正解3が違う")
        XCTAssert(quizModel?.displayFlag == "0", "表示になっていない")
        XCTAssertNotNil(quizModel?.createTime, "createTimeがセットされていない")

    }

    /// クイズの編集テスト
    func test_updateQuizModelTest() {

        QuizModel.addQuiz(UIViewController(),
                          title: "UnitTest",
                          correctAnswer: "correctAnswer",
                          incorrectAnswer1: "incorrectAnswer1",
                          incorrectAnswer2: "incorrectAnswer2",
                          incorrectAnswer3: "incorrectAnswer3",
                          displayFlag: "0",
                          quizType: ""
        )
        let quizModel = QuizModel.findQuiz(UIViewController(), quizid: "1", createTime: nil)

        QuizModel.updateQuiz(UIViewController(),
                             id: quizModel!.id,
                             createTime: quizModel?.createTime,
                             title: "updateUnitTest",
                             correctAnswer: "updatecorrectAnswer",
                             incorrectAnswer1: "updateincorrectAnswer1",
                             incorrectAnswer2: "updateincorrectAnswer2",
                             incorrectAnswer3: "updateincorrectAnswer3",
                             displayFlag: "0",
                             quizType: ""
        )

        XCTAssert(quizModel?.quizTitle == "updateUnitTest", "タイトルが違う")
        XCTAssert(quizModel?.trueAnswer == "updatecorrectAnswer", "正解が違う")
        XCTAssert(quizModel?.falseAnswer1 == "updateincorrectAnswer1", "不正解1が違う")
        XCTAssert(quizModel?.falseAnswer2 == "updateincorrectAnswer2", "不正解2が違う")
        XCTAssert(quizModel?.falseAnswer3 == "updateincorrectAnswer3", "不正解3が違う")
        XCTAssert(quizModel?.displayFlag == "0", "表示になっていない")

    }

    /// クイズ削除テスト
    func test_deleteQuizModelTest() {        
        QuizModel.addQuiz(UIViewController(), title: "UnitTest",
                          correctAnswer: "correctAnswer",
                          incorrectAnswer1: "incorrectAnswer1",
                          incorrectAnswer2: "incorrectAnswer2",
                          incorrectAnswer3: "incorrectAnswer3",
                          displayFlag: "0",
                          quizType: ""
        )

        let quizModel = QuizModel.findQuiz(UIViewController(), quizid: "1", createTime: nil)

        QuizModel.deleteQuiz(UIViewController(),
                             id: quizModel!.id,
                             createTime: quizModel?.createTime
        )

        let allquizModel = QuizModel.allFindQuiz(UIViewController())
        XCTAssert(allquizModel.count == 0, "クイズが削除されていない")

    }

    /// 選択したカテゴリのクイズが格納されるかテスト
    func test_selectQuizModelTest() {

        QuizCategoryModel.addQuizCategoryModel(UIViewController(), categorytitle: "カテゴリ1")
        QuizCategoryModel.updateisSelect(UIViewController(), selectCategory: QuizCategoryModel.findQuizCategoryModel(UIViewController(), id: "1", createTime: nil)!)
        var title: String
        var correctAnswer: String
        var incorrectAnswer1: String
        var incorrectAnswer2: String
        var incorrectAnswer3: String
        var displayFlag: String
        var quizType: String

        for i in 0..<30 {
            if i % 2 == 0 {
                title = "UnitTest\(String(i))"
                correctAnswer = "correctAnswer"
                              incorrectAnswer1 = "incorrectAnswer1"
                              incorrectAnswer2 = "incorrectAnswer2"
                              incorrectAnswer3 = "incorrectAnswer3"
                              displayFlag = "0"
                              quizType = "1"
            } else {
                title = "UnitTest\(String(i))"
                correctAnswer = "correctAnswer"
                              incorrectAnswer1 = "incorrectAnswer1"
                              incorrectAnswer2 = "incorrectAnswer2"
                              incorrectAnswer3 = "incorrectAnswer3"
                              displayFlag = "0"
                              quizType = ""
            }
            sleep(1)
            QuizModel.addQuiz(UIViewController(),
                              title: title,
                              correctAnswer: correctAnswer,
                              incorrectAnswer1: incorrectAnswer1,
                              incorrectAnswer2: incorrectAnswer2,
                              incorrectAnswer3: incorrectAnswer3,
                              displayFlag: displayFlag,
                              quizType: quizType
            )
        }
        let quizModel = QuizModel.selectQuiz(UIViewController())

        for quiz in quizModel {
            XCTAssert(quiz.quizTypeModel == QuizCategoryModel.findQuizCategoryModel(UIViewController(), id: "1", createTime: nil), "選択されたものが追加されていない")
        }

    }

}
