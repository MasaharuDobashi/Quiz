//
//  QuizTypeModel.swift
//  Quiz
//
//  Created by 土橋正晴 on 2020/04/12.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import RealmSwift

class QuizTypeModel: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var quizTypeTitle: String = ""
    @objc dynamic var isSelect: String = ""
    
}

