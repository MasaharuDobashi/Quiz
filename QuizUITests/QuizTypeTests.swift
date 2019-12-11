//
//  QuizTypeTests.swift
//  QuizUITests
//
//  Created by 土橋正晴 on 2019/12/11.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import XCTest


protocol QuizTypeTestsProtocol {
    
    /// クイズの種類の作成
    func test_quizTypeCreate()
    
    /// クイズの種類の編集
    func test_quizTypeEdit()
    
    /// クイズの種類の削除
    func test_quizTypeDelete()
}

class QuizTypeTests: XCTestCase, QuizTypeTestsProtocol {
    
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

    
    
    func test_quizTypeCreate() {
        
        let title = "自動テストタイプ"
        let app = XCUIApplication()
        app.tabBars.buttons.element(boundBy: 2).tap()
        sleep(1)
        app.navigationBars.buttons["Add"].tap()
        sleep(3)
        
        app.textFields.firstMatch.tap()
        app.typeText(title)
        
        app.navigationBars.containing(.button, identifier: "Stop").buttons["Add"].tap()
        app.alerts.buttons["閉じる"].tap()
        
        sleep(2)
        
        XCTAssert(app.tables.cells.firstMatch.staticTexts[title].exists, "入力したタイトルと違う")
    }
    
    func test_quizTypeEdit() {
        let app = XCUIApplication()
        
        let title = "自動テストタイプ"
        
        app.tabBars.buttons.element(boundBy: 2).tap()
        sleep(1)
        app.navigationBars.buttons["Add"].tap()
        sleep(3)
        
        app.textFields.firstMatch.tap()
        app.typeText(title)
        
        app.navigationBars.containing(.button, identifier: "Stop").buttons["Add"].tap()
        sleep(1)
        app.alerts.buttons["閉じる"].tap()
        
        sleep(2)
        app.tables.cells.firstMatch.staticTexts[title].swipeLeft()
        sleep(1)
        app.buttons["編集"].tap()
        
        let editTitle = "自動テストタイプ"
        app.textFields.firstMatch.tap()
        
        for _ in 0..<title.count {
            app.keys["delete"].tap()
        }
        app.typeText(editTitle)
        
        sleep(2)
        app.navigationBars.containing(.button, identifier: "Stop").buttons["Add"].tap()
        sleep(1)
        app.alerts.buttons["閉じる"].tap()
        sleep(1)
        
        XCTAssert(app.tables.cells.firstMatch.staticTexts[editTitle].exists, "入力したタイトルと違う")
        
        
        
        
        
    }
    
    func test_quizTypeDelete() {
        let app = XCUIApplication()
        
        let title = "自動テストタイプ"
        
        app.tabBars.buttons.element(boundBy: 2).tap()
        sleep(1)
        app.navigationBars.buttons["Add"].tap()
        sleep(3)
        
        app.textFields.firstMatch.tap()
        app.typeText(title)
        
        app.navigationBars.containing(.button, identifier: "Stop").buttons["Add"].tap()
        app.alerts.buttons["閉じる"].tap()
        
        sleep(2)
        
        app.tables.cells.firstMatch.staticTexts[title].swipeLeft()
        sleep(1)
        app.buttons["削除"].tap()
        sleep(2)
        
        XCTAssert(!app.tables.cells.firstMatch.staticTexts[title].exists, "削除されていない")
    }
    
    
    
    
    
}

