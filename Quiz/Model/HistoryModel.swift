//
//  HistoryModel.swift
//  Quiz
//
//  Created by 土橋正晴 on 2020/04/12.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import RealmSwift

class HistoryModel: Object {
    @objc dynamic var quizTrueCount: String = ""
    @objc dynamic var date: String = ""
}



