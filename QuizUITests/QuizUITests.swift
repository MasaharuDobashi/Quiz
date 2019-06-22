//
//  QuizUITests.swift
//  QuizUITests
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import XCTest

//@testable import Quiz
class QuizUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
  
        
    }
    
    
    
    
    /// クイズをx個作成
    func testCreateQuiz(){
        let app = XCUIApplication()
        app.tabBars.buttons["Most Viewed"].tap()
        
        for i in 0..<10 {
        app.navigationBars["Quiz.QuizManagementView"].buttons["Add"].tap()
            if i == 0 {
                app.navigationBars.containing(.button, identifier: "Stop").buttons["Add"].tap()
                app.alerts.buttons["閉じる"].tap()
            }
        app.tables.textFields["クイズのタイトルを入力してください。"].tap()
        app.tables.textFields["クイズのタイトルを入力してください。"].typeText("自動テスト\(String(i + 1))")
        app.tables.textFields["正解の回答を入力してください。"].tap()
        app.tables.textFields["正解の回答を入力してください。"].typeText("正解1")
        app.tables.textFields["false1"].tap()
        app.tables.textFields["false1"].typeText("不正解1")
        app.tables.textFields["false2"].tap()
        app.tables.textFields["false2"].typeText("不正解2")
        app.tables.textFields["false3"].tap()
        app.tables.textFields["false3"].typeText("不正解3")
        app.navigationBars.containing(.button, identifier: "Stop").buttons["Add"].tap()
        app.alerts.buttons["閉じる"].tap()
        }
        
        
        
    }
    
    
    func testQuizStart(){
        let app = XCUIApplication()
//        app.tables.buttons["Favorites"].tap()
        app.buttons["クイズスタート"].tap()
    }

    
}
