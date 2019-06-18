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
    
    private var historyView: HistoryView!
    private var realm: Realm!
    private var historyModel: [HistoryModel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyModel = [HistoryModel]()
        realm = try! Realm()
        
        for i in 0..<realm.objects(HistoryModel.self).count {
            historyModel.append(realm.objects(HistoryModel.self)[i])
            
            historyModel.sort{
                $0.date < $1.date
            }
        }
        historyView = HistoryView(frame: frame_Size(self), historyModel: historyModel)
        view.addSubview(historyView)
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint(object: historyModel)
        
        historyView.lineAnimetion()
    }
    
}
