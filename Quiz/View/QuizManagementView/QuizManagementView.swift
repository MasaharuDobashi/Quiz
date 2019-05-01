//
//  QuizCreateView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/26.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit


protocol QuizManagementViewDelegate: class {
    func editAction(indexPath:IndexPath)
    func deleteAction(indexPath:IndexPath)
    func detailAction(indexPath:IndexPath)
}

 class QuizManagementView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var quizModel:[QuizModel]?
    
    weak var quizManagementViewDelegate:QuizManagementViewDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    
    convenience init(frame: CGRect, style: UITableView.Style, quizModel: [QuizModel]) {
        self.init(frame: frame, style: style)
        
        self.quizModel = quizModel
        
        self.delegate = self
        self.dataSource = self
        self.separatorInset = .zero
        self.register(QuizListCell.self, forCellReuseIdentifier: "quizCell")
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:QuizListCell = tableView.dequeueReusableCell(withIdentifier: "quizCell") as! QuizListCell
    
        
        switch indexPath.section {
        case 0:
            if quizModel?.count == 0 {
                cell.textLabel?.text = "まだクイズが作成されていません"
                
                return cell
            }
            
            cell.setCell(quizNo: "問題\(indexPath.row + 1)", quizTitle: (quizModel?[indexPath.row].quizTitle)!)
            
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
    
}





fileprivate final class QuizListCell:UITableViewCell {
    let quizNoLabel:UILabel = UILabel()
    let quizTitleLabel:UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(quizNoLabel)
        self.contentView.addSubview(quizTitleLabel)
        
        quizNoLabel.translatesAutoresizingMaskIntoConstraints = false
        quizNoLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        quizNoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        quizNoLabel.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        quizNoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        quizTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        quizTitleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        quizTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70 + 30).isActive = true
        quizTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        quizTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(quizNo:String, quizTitle:String){
        quizNoLabel.text = quizNo
        quizTitleLabel.text = quizTitle
    }
}
