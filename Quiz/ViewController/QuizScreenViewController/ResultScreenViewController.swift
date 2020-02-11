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
    
    private var realm: Realm?
    
    /// 履歴を格納する
    private var historyModel: HistoryModel!
    
    /// 正解数
    private var trueConunt: Int = 0
    
    
    private lazy var resultScreenView:ResultScreenView = {
        let resultScreenView:ResultScreenView = ResultScreenView(frame: frame_Size(self))
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
        
        addRealm(trueConunt: trueConunt)
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
            NotificationCenter.default.post(name: Notification.Name(R.notification.ViewUpdate), object: nil)
        }
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resultScreenView.animation()
    }
    
    
    private func addRealm(trueConunt: Int){
        let conunt: String = String(trueConunt)
        historyModel = HistoryModel()
        
        
        historyModel.quizTrueCount = conunt
        historyModel.date = nowDate()
        
        
        do {
            realm = try Realm(configuration: Realm.Configuration(schemaVersion: realmConfig))
            try realm?.write() {
                realm?.add(historyModel)
            }
        } catch {
            AlertManager().alertAction(viewController: self, title: nil, message: R.string.error.errorMessage, handler: { _ in
                return
            })
            return
        }
        
        if (realm?.objects(HistoryModel.self).count)! > 30 {
            deleteRealm()
        }
        
        debugPrint(object: historyModel)
    }
    
    
    
    
    
    private func deleteRealm(){
        var historyModel:[HistoryModel] = [HistoryModel]()
        for i in 0..<(realm?.objects(HistoryModel.self).count)! {
            historyModel.append((realm?.objects(HistoryModel.self)[i])!)
            
            historyModel.sort{
                $0.date < $1.date
            }
        }
        
        debugPrint(object: historyModel.first)
        
        
        do {
            try realm?.write() {
                realm?.delete(historyModel.first!)
            }
        } catch {
            AlertManager().alertAction(viewController: self, title: nil, message: R.string.error.errorMessage, handler: { _ in
                return
            })
            return
        }
        
        
    }
    
    
    
    /// 時間を整形
    func nowDate() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd hh:mm"
        let now = Date()
        return format.string(from: now)
    }
    
}
