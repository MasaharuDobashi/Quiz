//
//  HistoryViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/06/11.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

final class HistoryViewController: UIViewController {
    
    // MARK: Properties
    
    private lazy var historyView: HistoryView = {
        let historyView: HistoryView = HistoryView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.bounds.height)! +  UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - ((self.navigationController?.navigationBar.bounds.height)! + UIApplication.shared.statusBarFrame.size.height)), historyModel: historyModel)
        
        return historyView
    }()
    
    private var historyModel: [HistoryModel]!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = cellWhite
        
        historyModel = HistoryModel.allFindHistory(self)
        
        
        view.addSubview(historyView)
    
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint(object: historyModel)
        
        historyView.lineAnimetion()
    }
    
}
