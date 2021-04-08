//
//  HistoryModelTests.swift
//  QuizTests
//
//  Created by 土橋正晴 on 2020/04/20.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest

@testable import Quiz

class HistoryModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        RealmManager().allDelete()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// 履歴の追加テスト
    func testAddHistory() {
        HistoryModel.addHistory(UIViewController(), count: 5)

        let historyModel = HistoryModel.allFindHistory(UIViewController())

        XCTAssert(historyModel[0].quizTrueCount == "5", "設定した値が入っていない")
        XCTAssertNotNil(historyModel[0].date, "日時が入っていない")
    }

    /// 履歴に30件以上登録されないことを確認テスト
    func testAddHistory_max() {

        for i in 0..<35 {
            HistoryModel.addHistory(UIViewController(), count: i)
        }

        let historyModel = HistoryModel.allFindHistory(UIViewController())
        XCTAssertTrue(historyModel.count == 30, "30件以上登録されている")
    }

}
