//
//  ResultScreenViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

class ResultScreenViewController: UIViewController {
    
    // MARK: Properties
    
    private var realm: Realm!
    private var historyModel: HistoryModel!
    private var trueConunt: Int = 0
    
    // MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(trueConunt:Int){
        self.init(nibName: nil, bundle: nil)
        self.trueConunt = trueConunt
        
        addRealm(trueConunt: trueConunt)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
        
        let resultScreenView:ResultScreenView = ResultScreenView(frame: frame_Size(self), trueConunt:trueConunt)
        self.view.addSubview(resultScreenView)
    }
    
    private func addRealm(trueConunt: Int){
        let conunt: String = String(trueConunt)
        historyModel = HistoryModel()
        realm = try! Realm()
        #if DEBUG
        print("true: \(conunt)\ndate: \(nowDate())")
        #endif
        
        
        historyModel.quizTrueCount = conunt
        historyModel.date = nowDate()
        
        
        try! realm.write() {
            realm.add(historyModel)
        }
    }
    
    
    func nowDate() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd hh:mm"
        let now = Date()
        return format.string(from: now)
    }
    
}
