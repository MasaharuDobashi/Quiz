//
//  QuizCreateView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/26.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift


protocol QuizManagementViewDelegate: class {
    func editAction(indexPath:IndexPath)
    func deleteAction(indexPath:IndexPath)
    func detailAction(indexPath:IndexPath)
}

class QuizManagementView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var tableView:UITableView?
    private let realm:Realm = try! Realm()
    weak var quizManagementViewDelegate:QuizManagementViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewload()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewload(){
        
        
        if realm.objects(QuizModel.self).count == 0 {
            let label:UILabel = UILabel()
            label.text = "まだクイズが作成されていません"
            label.sizeToFit()
            self.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: label.bounds.height).isActive = true
            label.widthAnchor.constraint(equalToConstant: label.bounds.width).isActive = true
            
            return
        }
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorInset = .zero
        self.addSubview(tableView!)
        
        
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        tableView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(QuizModel.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
    
        
        switch indexPath.section {
        case 0:
            
            let label:UILabel = UILabel()
            label.text = "問題\(indexPath.row + 1)"
            label.sizeToFit()
            cell.contentView.addSubview(label)
            
            let questionLabel:UILabel = UILabel()
            questionLabel.text = realm.objects(QuizModel.self)[indexPath.row].quizTitle
            questionLabel.numberOfLines = 0
            cell.contentView.addSubview(questionLabel)
            
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20).isActive = true
            label.widthAnchor.constraint(equalToConstant: label.bounds.width).isActive = true
            label.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            
            questionLabel.translatesAutoresizingMaskIntoConstraints = false
            questionLabel.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            questionLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 70 + 30).isActive = true
            questionLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            questionLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        default:
            break
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        quizManagementViewDelegate?.detailAction(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "編集") { [weak self]
            (action, indexPath) in
            
            self?.quizManagementViewDelegate?.editAction(indexPath: indexPath)
        }
        
        edit.backgroundColor = UIColor.orange
        
        
        let del = UITableViewRowAction(style: .destructive, title: "削除") { [weak self]
         (action, indexPath) in
            
            self?.quizManagementViewDelegate?.deleteAction(indexPath: indexPath)
            
        }

        return [edit, del]
    }
    
    
    func deleteRealm(indexPath: IndexPath){
        let toDoModel = realm.objects(QuizModel.self)[indexPath.row]
        
        try! realm.write() {
            realm.delete(toDoModel)
        }
        
    }
    
}
