//
//  ResultScreenViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

final class ResultScreenViewController: UIViewController {
    
    // MARK: Properties
    
    /// 履歴を格納する
    private var historyModel: Results<HistoryModel>!
    
    /// 正解数
    private var trueConunt: Int = 0
    
    
    private lazy var resultScreenView:ResultScreenView = {
        let resultScreenView:ResultScreenView = ResultScreenView(frame: frame)
        resultScreenView.correctString = String(self.trueConunt)
        
        return resultScreenView
    }()
    
    
    
    
    // MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    convenience init(trueConunt:Int){
        self.init(nibName: nil, bundle: nil)
        self.trueConunt = trueConunt
        
        HistoryModel.addHistory(self, count: trueConunt)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
        
        view.addSubview(resultScreenView)
        
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.post(name: Notification.Name(R.string.notifications.viewUpdate()), object: nil)
        }
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resultScreenView.animation()
    }
    
}
