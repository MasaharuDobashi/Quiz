//
//  QuizMainViewTest.swift
//  QuizTests
//
//  Created by 土橋正晴 on 2020/01/28.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import Quiz


protocol QuizMainViewTestProtocol {
    /// isActiveQuizのBool値ごとにテキストが変更されることをテスト
    func testStartButton()
    
    /// isQuizTypeのBool値ごとにテキストが変更されることをテスト
    func testTypeButton()
    
    /// isHistoryのBool値ごとにhistoryButtonがあるかどうかのテスト
    func testHistoryButton()
    
}


class QuizMainViewTest: XCTestCase, QuizMainViewTestProtocol {
    
    
    var quizMainView: QuizMainView!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        quizMainView = QuizMainView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    
    func testStartButton() {
        
        quizMainView.isActiveQuiz = false
        quizMainView.startButtonColorChange()
        XCTAssert(quizMainView.quizStartButton.titleLabel?.text == "クイズを作成", "テキストが違う")
        
        quizMainView.isActiveQuiz = true
        quizMainView.startButtonColorChange()
        XCTAssert(quizMainView.quizStartButton.titleLabel?.text == "クイズスタート", "テキストが違う")
    }
    
    
    
    func testTypeButton() {
        let quizMainView = QuizMainView()
        quizMainView.isQuizType = false
        quizMainView.typeButtonColorChange()
        XCTAssert(quizMainView.quizTypeButton.titleLabel?.text == "クイズのカテゴリを作成", "テキストが違う")
        
        quizMainView.isQuizType = true
        quizMainView.typeButtonColorChange()
        XCTAssert(quizMainView.quizTypeButton.titleLabel?.text == "カテゴリの選択", "テキストが違う")
    }
    
    
    
    func testHistoryButton() {
        let quizMainView = QuizMainView()
        quizMainView.isHistory = false
        quizMainView.historyButtonColorChange()
        XCTAssert(!quizMainView.historyButton.isDescendant(of: quizMainView), "addSubviewされている")
        
        quizMainView.isHistory = true
        quizMainView.historyButtonColorChange()
        XCTAssert(quizMainView.historyButton.isDescendant(of: quizMainView), "addSubviewdされていない")
    }
    
    

}
