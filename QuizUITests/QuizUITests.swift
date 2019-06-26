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
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
  
        
    }
    
    
    
    /// クイズをx個作成
    func testQuiz1_Create(){
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
    
    
    /// クイズスタートから履歴画面まで
    func testQuiz2_Start(){
        let app = XCUIApplication()
        
        let startButton = app.buttons["クイズスタート"]
        XCTAssert(startButton.exists, "問題が作成されていない")
        app.buttons["quizStartButton"].tap()
        
        
        if app.alerts["利用可能なクイズが10問を超えています。"].exists == true{
            
            alertCount += 1
            app.buttons["閉じる"].tap()
            
            app.tabBars.buttons["Most Viewed"].tap()
            app.tables.staticTexts["問題\(String(alertCount))"].swipeLeft()
            app.tables.buttons["編集"].tap()
            
            app.tables.switches["switch"].tap()
            app.navigationBars.containing(.button, identifier: "Stop").buttons["Add"].tap()
            app.alerts.buttons["閉じる"].tap()
            app.tabBars.buttons["Favorites"].tap()
            
            
            
            app.tabBars.buttons["Favorites"].tap()
            
            self.testQuiz2_Start()
         
        }
   
        
        
        while app.buttons["正解1"].exists == true {
            app.buttons["正解1"].tap()
        }
        
        
        sleep(3)
        app.navigationBars["Quiz.ResultScreenView"].buttons["Stop"].tap()
        
        
    }
    
    func testQuiz3_Edit(){
        let app = XCUIApplication()
        
        app.tabBars.buttons["Most Viewed"].tap()
        app.tables.staticTexts["問題1"].swipeLeft()
        app.tables.buttons["編集"].tap()
        
        
        var text:String = app.textFields["title"].value as! String
        app.textFields["title"].tap()
        for _ in 0..<text.count{
            app.keys["delete"].tap()
        }
        
        app.typeText("自動編集テスト")
        text = app.textFields["true"].value as! String
        
        app.textFields["true"].tap()
        for _ in 0..<text.count{
            app.keys["delete"].tap()
        }
        app.typeText("自動編集(正解)")
        
        text = app.textFields["false1"].value as! String
        app.textFields["false1"].tap()
        for _ in 0..<text.count{
            app.keys["delete"].tap()
        }
        app.typeText("自動編集(不正解1)")
        
        text = app.textFields["false2"].value as! String
        app.textFields["false2"].tap()
        for _ in 0..<text.count{
            app.keys["delete"].tap()
        }
        
        text = app.textFields["false3"].value as! String
        app.typeText("自動編集(不正解2)")
        
        app.textFields["false3"].tap()
        for _ in 0..<text.count{
            app.keys["delete"].tap()
        }
        app.typeText("自動編集(不正解3)")
        
        
        app.navigationBars.containing(.button, identifier: "Stop").buttons["Add"].tap()
        app.alerts.buttons["閉じる"].tap()
        sleep(2)
    }
    
    
    func testQuiz4_Delete(){
        let app = XCUIApplication()
        app.tabBars.buttons["Most Viewed"].tap()
        app.tables.staticTexts["問題1"].swipeLeft()
        app.tables.buttons["削除"].tap()
        
        app.alerts.buttons["削除"].tap()
        sleep(2)
        
    }
    
    func testQuiz5_History(){
        
        let app = XCUIApplication()
        app.buttons["historyButton"].tap()
        
        sleep(5)
        
        app.navigationBars["Quiz.HistoryView"].buttons["Back"].tap()
    }
    
    
    func testQuiz6_AllDelete(){
        #if DEBUG
        let app = XCUIApplication()
        app.tabBars.buttons["Most Viewed"].tap()
        app.navigationBars.buttons["allDelete"].tap()
        app.alerts.buttons["閉じる"].tap()
        
        
        app.navigationBars.buttons["allDelete"].tap()
        app.alerts.buttons["削除"].tap()
        #endif
        
    }
}
