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


/// クイズのカテゴリのVC
final class QuizTypeEditViewController: UIViewController {
    
    // MARK: Properties
        
    /// 新規追加、編集、詳細の判別
    private var mode: ModeEnum = ModeEnum.add
    
    /// クイズのカテゴリのID
    private var typeid: String?
    
    private var filter: QuizCategoryModel?
    
    /// クイズのカテゴリのビュー
    lazy var quizTypeEditView: QuizTypeEditView = {
        let view: QuizTypeEditView = QuizTypeEditView(frame: frame, style: .grouped, mode: self.mode)
        
        if self.mode != .add {
            view.typeTextField.text = filter?.quizTypeTitle
        } else if self.mode == .detail {
            view.typeTextField.isEnabled = false
        }
        return view
    }()
    
    
    
    // MARK: Init
    
    convenience init(typeid: String?, createTime: String?, mode: ModeEnum){
        self.init()
        self.mode = mode
        
        if let _typeid = typeid,
        let _createTime = createTime {
            filter = QuizCategoryModel.findQuizCategoryModel(self, id: _typeid, createTime: _createTime)
        }
    }
    
    
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.color.cellWhite()
        
        if mode != .detail {
            navigationItemAction()
        }
        
        view.addSubview(quizTypeEditView)
    }
    
    
    
    
    // MARK: NavigationItem Func
    
    override func rightButtonAction(){
        realmAction()
    }
    
    
    
    // MARK: Realm Func
    
    private func realmAction() {
        
        if mode == .add {
            addRealm()
            AlertManager.alertAction( self, title: nil, message: "問題を作成しました", didTapCloseButton: { [weak self] Void in
                self?.leftButtonAction()
            })
        } else if mode == .edit {
            updateRealm()
            AlertManager.alertAction( self, title: nil, message: "問題を更新しました", didTapCloseButton: { [weak self] Void in
                self?.leftButtonAction()
            })
        }
        
        
        
        NotificationCenter.default.post(name: Notification.Name(R.string.notifications.quizTypeUpdate()), object: nil)
    }
    
    
    /// Realmに新規追加
    private func addRealm(){
        QuizCategoryModel.addQuizCategoryModel(self, categorytitle: quizTypeEditView.typeTextField.text!)
        
    }
    
    
    /// アップデート
    private func updateRealm() {
        
        QuizCategoryModel.updateQuizCategoryModel(self, id: filter!.id, createTime: filter?.createTime, categorytitle: quizTypeEditView.typeTextField.text!)
        
        
    }
}
