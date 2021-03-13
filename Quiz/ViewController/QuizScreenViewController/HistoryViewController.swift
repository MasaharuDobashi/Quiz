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
    
    private var historyView: HistoryView?
    
    private var historyModel: [HistoryModel]!
    
    private let statusBarHeight = UIWindow().windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = R.color.cellWhite()
        
        setHistoryView()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint(object: historyModel)
        
        historyView?.lineAnimetion()
    }
    
    
    
    
    // MARK: private func
    
    private func setHistoryView() {
        historyModel = HistoryModel.allFindHistory(self)
        historyView = HistoryView(frame: CGRect(x: 0,
                                                y: (navigationController?.navigationBar.bounds.height)! + statusBarHeight,
                                                width: view.frame.width,
                                                height: view.frame.height),
                                  historyModel: historyModel)
        guard let _historyView = historyView else { return }
        view.addSubview(_historyView)
    }
    
    
}
