//
//  QuizTypeManagementView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/11/03.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit


class QuizTypeManagementView: UITableView {
    
    // MARK: Properties
    
    
    
    /// クイズのすカテゴリの配列
    var quizTypeModel: [QuizCategoryModel]? {
        didSet {
            reloadData()
        }
    }
    
    
    
    // MARK: Init
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
//        dataSource = self
//        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

    
}
