//
//  HistoryViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/06/11.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

final class HistoryViewController: UIViewController {
    
    // MARK: Properties
    
    private lazy var historyView: HistoryView = {
        let historyView: HistoryView = HistoryView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.bounds.height)! +  UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - ((self.navigationController?.navigationBar.bounds.height)! + UIApplication.shared.statusBarFrame.size.height)), historyModel: historyModel)
        
        return historyView
    }()
    
    private var realm: Realm!
    private var historyModel: [HistoryModel]!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = cellWhite

        historyModel = [HistoryModel]()
        realm = try! Realm()
        
        for i in 0..<realm.objects(HistoryModel.self).count {
            historyModel.append(realm.objects(HistoryModel.self)[i])
            
            historyModel.sort{
                $0.date < $1.date
            }
        }
        
        view.addSubview(historyView)
    
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint(object: historyModel)
        
        historyView.lineAnimetion()
    }
    
}
