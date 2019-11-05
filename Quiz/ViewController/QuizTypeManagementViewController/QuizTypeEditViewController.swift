//
//  QuizTypeEditViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/11/04.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class QuizTypeEditViewController: UIViewController {
    
    // MARK: Properties
    
    private var realm:Realm!
    private let config = Realm.Configuration(schemaVersion: 1)
    
    /// 新規追加、編集、詳細の判別
    private var mode: ModeEnum = ModeEnum.add
    
    var typeid: Int?
    
    lazy var quizTypeEditView: QuizTypeEditView = {
        let view: QuizTypeEditView = QuizTypeEditView(frame: frame_Size(self))
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm(configuration: config)
        
        view.backgroundColor = cellWhite
        navigationItemAction()
        view.addSubview(quizTypeEditView)
    }
    
    
    
    
    
    private func navigationItemAction(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
    }
    
    @objc private func rightButtonAction(){

        realmAction()
    }
    
    
    
    // MARK: Realm Func
    
    private func realmAction() {
        
        if mode == .add {
            addRealm()
            AlertManager().alertAction(viewController: self, title: nil, message: "問題を作成しました", handler: { [weak self] Void in
                self?.leftButtonAction()
            })
        } else if mode == .edit {
            updateRealm()
            AlertManager().alertAction(viewController: self, title: nil, message: "問題を更新しました", handler: { [weak self] Void in
                self?.leftButtonAction()
            })
        }
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.post(name: Notification.Name(ViewUpdate), object: nil)
        }
        
        
        NotificationCenter.default.post(name: Notification.Name(quizTypeUpdate), object: nil)
    }
    
    
    /// Realmに新規追加
    private func addRealm(){
        let quizTypeModel = QuizTypeModel()
        realm = try! Realm(configuration: config)
        
        quizTypeModel.id = String(realm.objects(QuizTypeModel.self).count)
        quizTypeModel.quizTypeTitle = quizTypeEditView.typeTextField.text!
        
        try! realm.write() {
            realm.add(quizTypeModel)
        }
    }
    
    
    /// アップデート
    private func updateRealm(){
        try! realm.write() {
            realm.objects(QuizTypeModel.self)[0].quizTypeTitle = quizTypeEditView.typeTextField.text!
        }
    }
}
