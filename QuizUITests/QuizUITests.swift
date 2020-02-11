//
//  QuizUITests.swift
//  QuizUITests
//
//  Created by 土橋正晴 on 2019/08/25.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import XCTest



class ShortcutManager: XCTestCase {
    
    class func quizDelete(){
        #if DEBUG
        let app = XCUIApplication()
        app.tabBars.buttons["クイズ"].tap()
        app.navigationBars.buttons["allDelete"].tap()
        app.alerts.buttons["閉じる"].tap()
        
        
        app.navigationBars.buttons["allDelete"].tap()
        app.alerts.buttons["削除"].tap()
        #endif
        
    }
    
    
    
    
    /// クイズをx個作成
    class func quizCreate(_ editCount:Int) {
        let app = XCUIApplication()
        app.tabBars.buttons["クイズ"].tap()
        
        for i in 0..<editCount {
            app.navigationBars["Quiz.QuizManagementView"].buttons["Add"].tap()
            
            
            app.tables.textFields["title"].tap()
            app.tables.textFields["title"].typeText("自動テスト\(String(i + 1))")
            app.tables.textFields["correctAnswer"].tap()
            app.tables.textFields["correctAnswer"].typeText("正解1")
            app.tables.textFields["incorrectAnswer1"].tap()
            app.tables.textFields["incorrectAnswer1"].typeText("不正解1")
            app.tables.textFields["incorrectAnswer2"].tap()
            app.tables.textFields["incorrectAnswer2"].typeText("不正解2")
            app.tables.textFields["incorrectAnswer3"].tap()
            app.tables.textFields["incorrectAnswer3"].typeText("不正解3")
            
            
            
            
            app.toolbars.buttons.firstMatch.tap()
            app.swipeUp()
            if app.staticTexts["クイズのカテゴリ"].exists {
                app.textFields["quizType"].tap()
                app.pickers.firstMatch.swipeDown()
                app.toolbars.buttons.firstMatch.tap()
            }
            
            app.navigationBars.containing(.button, identifier: "Stop").buttons["Add"].tap()
            app.alerts.buttons["閉じる"].tap()
        }
        
        app.tabBars.buttons["メイン"].tap()
        
    }

    
    
}

//@testable import Quiz
class QuizUITests: XCTestCase {
    
    var alertCount:Int = 0

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
        ShortcutManager.quizDelete()
        
    }


    
    

    
    
    
    func test_EditViewUI(){
        
        
        let app = XCUIApplication()
        app.tabBars.buttons["クイズ"].tap()
        
        app.navigationBars["Quiz.QuizManagementView"].buttons["Add"].tap()
        
        XCTAssertEqual(app.tables.textFields["title"].value as! String, "クイズのタイトルを入力してください。", "プレースホルダーのテキストが違う")
        XCTAssertEqual(app.tables.staticTexts["title"].label, "タイトル", "プレースホルダーのテキストが違う")
        
        
        
        XCTAssertEqual(app.tables.textFields["correctAnswer"].value as! String, "正解の回答を入力してください。", "プレースホルダーのテキストが違う")
        XCTAssertEqual(app.tables.staticTexts["correctAnswer"].label, "正解", "ヘッダーのテキストが違う")
        
        
        
        XCTAssertEqual(app.tables.textFields["incorrectAnswer1"].value as! String, "不正解の回答を入力してください。", "プレースホルダーのテキストが違う")
        XCTAssertEqual(app.tables.staticTexts["incorrectAnswer1"].label, "不正解1", "ヘッダーのテキストが違う")
        
        
        
        XCTAssertEqual(app.tables.textFields["incorrectAnswer2"].value as! String, "不正解の回答を入力してください。", "プレースホルダーのテキストが違う")
        XCTAssertEqual(app.tables.staticTexts["incorrectAnswer2"].label, "不正解2", "ヘッダーのテキストが違う")
        
        
        
        XCTAssertEqual(app.tables.textFields["incorrectAnswer3"].value as! String, "不正解の回答を入力してください。", "プレースホルダーのテキストが違う")
        XCTAssertEqual(app.tables.staticTexts["incorrectAnswer3"].label, "不正解3", "ヘッダーのテキストが違う")
        
        
        XCTAssert(app.tables.staticTexts[" 表示・非表示"].exists, "ラベルのテキストが違う")
        XCTAssertEqual(app.tables.staticTexts["showHide"].label, "表示", "ヘッダーのテキストが違う")
        
        app.tables.textFields["title"].tap()
        app.tables.textFields["title"].typeText("自動テスト1")
        app.tables.textFields["correctAnswer"].tap()
        
        app.tables.textFields["correctAnswer"].tap()
        app.tables.textFields["correctAnswer"].typeText("正解1")
        
        app.tables.textFields["incorrectAnswer1"].tap()
        app.tables.textFields["incorrectAnswer1"].typeText("不正解1")
        
        app.tables.textFields["incorrectAnswer2"].tap()
        app.tables.textFields["incorrectAnswer2"].typeText("不正解2")
        
        app.tables.textFields["incorrectAnswer3"].tap()
        app.tables.textFields["incorrectAnswer3"].typeText("不正解3")
        app.buttons["Return"].tap()
        
        app.tables.switches["showHide"].tap()
        app.tables.switches["showHide"].tap()
        
        app.navigationBars.containing(.button, identifier: "Stop").buttons["Add"].tap()
        app.alerts.buttons["閉じる"].tap()
        
    }
    
    
    
    /// クイズスタートから履歴画面まで
    func testQuizStart(){
        let app = XCUIApplication()
        
            ShortcutManager.quizCreate(10)
        let startButton = app.buttons["クイズスタート"]
        XCTAssert(startButton.exists, "問題が作成されていない")
        app.buttons["quizStartButton"].tap()
        
        
        if app.alerts["利用可能なクイズが10問を超えています。"].exists == true{
            
            alertCount += 1
            app.buttons["閉じる"].tap()
            
            app.tabBars.buttons["クイズ"].tap()
            app.tables.staticTexts["問題\(String(alertCount))"].swipeLeft()
            app.tables.buttons["編集"].tap()
            
            app.tables.switches["showHide"].tap()
            app.navigationBars.containing(.button, identifier: "Stop").buttons["Add"].tap()
            app.alerts.buttons["閉じる"].tap()
            app.tabBars.buttons["クイズ"].tap()
            
        }
        
        while app.buttons["正解1"].exists == true {
            app.buttons["正解1"].tap()
            sleep(1)
        }
        app.navigationBars["Quiz.ResultScreenView"].buttons["Stop"].tap()
    }
    
    func testQuizEdit(){
        ShortcutManager.quizCreate(1)
        let app = XCUIApplication()
        
        
        
        app.tabBars.buttons["クイズ"].tap()
        app.tables.staticTexts["問題1"].swipeLeft()
        app.tables.buttons["編集"].tap()
        
        
        var text:String = app.textFields["title"].value as! String
        app.textFields["title"].tap()
        for _ in 0..<text.count{
            app.keys["delete"].tap()
        }
        
        app.typeText("自動編集テスト")
        text = app.textFields["correctAnswer"].value as! String
        
        app.textFields["correctAnswer"].tap()
        for _ in 0..<text.count{
            app.keys["delete"].tap()
        }
        app.typeText("自動編集(正解)")
        
        text = app.textFields["incorrectAnswer1"].value as! String
        app.textFields["incorrectAnswer1"].tap()
        for _ in 0..<text.count{
            app.keys["delete"].tap()
        }
        app.typeText("自動編集(不正解1)")
        
        text = app.textFields["incorrectAnswer2"].value as! String
        app.textFields["incorrectAnswer2"].tap()
        for _ in 0..<text.count{
            app.keys["delete"].tap()
        }
        
        text = app.textFields["incorrectAnswer3"].value as! String
        app.typeText("自動編集(不正解2)")
        
        app.textFields["incorrectAnswer3"].tap()
        for _ in 0..<text.count{
            app.keys["delete"].tap()
        }
        app.typeText("自動編集(不正解3)")
        
        
        app.navigationBars.containing(.button, identifier: "Stop").buttons["Add"].tap()
        app.alerts.buttons["閉じる"].tap()
        sleep(2)
    }
    
    
    func testQuizDelete(){
        ShortcutManager.quizCreate(1)
        let app = XCUIApplication()
        app.tabBars.buttons["クイズ"].tap()
        
        XCTAssert(app.tables.staticTexts["問題1"].exists, "問題が作成されていない")
        
        app.tables.staticTexts["問題1"].swipeLeft()
        app.tables.buttons["削除"].tap()
        app.alerts.buttons["削除"].tap()
        
        
    }
    
    
    func testHistory(){
        ShortcutManager.quizCreate(10)
        let app = XCUIApplication()
        
        for _ in 0...10 {
            
            let startButton = app.buttons["クイズスタート"]
            startButton.tap()
            
            
            while app.buttons["正解1"].exists == true {
                app.buttons["正解1"].tap()
                sleep(1)
            }
            
            if app.waitForExistence(timeout: 2.0) == true {
                app.navigationBars["Quiz.ResultScreenView"].buttons["Stop"].tap()
            }
            
            
        }
        
        let historyButton = app.buttons["historyButton"]
        XCTAssert(historyButton.exists, "履歴が存在しない")
        
        
        historyButton.tap()
        
        if app.waitForExistence(timeout: 5.0) == true {
        
            app.navigationBars["Quiz.HistoryView"].buttons["Back"].tap()
        }
    }
    
    
    
    
}

