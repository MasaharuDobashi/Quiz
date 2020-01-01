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


/// クイズの種類のVC
final class QuizTypeEditViewController: UIViewController {
    
    // MARK: Properties
    
    private var realm: Realm?
    private let config = Realm.Configuration(schemaVersion: 1)
    
    /// 新規追加、編集、詳細の判別
    private var mode: ModeEnum = ModeEnum.add
    
    /// クイズの種類のID
    private var typeid: String?
    
    private var filter: QuizTypeModel?
    
    /// クイズの種類のビュー
    lazy var quizTypeEditView: QuizTypeEditView = {
        let view: QuizTypeEditView = QuizTypeEditView(frame: frame_Size(self), mode: self.mode)
        
        if self.mode != .add {
            view.typeTextField.text = filter?.quizTypeTitle
        } else if self.mode == .detail {
            view.typeTextField.isEnabled = false
        }
        return view
    }()
    
    
    
    // MARK: Init
    
    convenience init(typeid: String?, mode: ModeEnum){
        self.init()
        self.mode = mode
        
        do {
              realm = try Realm(configuration: Realm.Configuration(schemaVersion: realmConfig))
          } catch {
              AlertManager().alertAction(viewController: self, title: nil, message: "エラーが発生しました", handler: { _ in
                  return
              })
              return
          }
          
        
        if let _typeid = typeid {
            filter = self.realm?.objects(QuizTypeModel.self).filter("id == '\(String(describing: _typeid))'").first!
        }
    }
    
    
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm(configuration: config)
        
        view.backgroundColor = cellWhite
        
        if mode != .detail {
            navigationItemAction()
        }
        
        view.addSubview(quizTypeEditView)
    }
    
    
    
    
    // MARK: NavigationItem Func
    
    override func navigationItemAction() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))
    }
    
    override func rightButtonAction(){
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
        
        guard let id: Int = realm?.objects(QuizTypeModel.self).count else { return }
        
        quizTypeModel.id = String(id)
        quizTypeModel.quizTypeTitle = quizTypeEditView.typeTextField.text!
        
        do {
            try realm?.write() {
                realm?.add(quizTypeModel)
            }
        } catch {
            AlertManager().alertAction(viewController: self, title: nil, message: "エラーが発生しました", handler: { _ in
                return
            })
            return
        }
        
    }
    
    
    /// アップデート
    private func updateRealm(){
        
        do {
            try realm?.write() {
                filter?.quizTypeTitle = quizTypeEditView.typeTextField.text!
            }
        } catch {
            AlertManager().alertAction(viewController: self, title: nil, message: "エラーが発生しました", handler: { _ in
                return
            })
            return
        }
        
    }
}
