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
    
    // MARK: Properties
    
    var quizModel:[QuizModel]?
    private let noneLabel:UILabel = {
        let label:UILabel = UILabel(title: "まだクイズが作成されていません",
                                    font: UIFont.systemFont(ofSize: 18),
                                    textColor: .black,
                                    backgroundColor: .lightGray,
                                    textAlignment: .center,
                                    numberOfLines: 0
        )
        label.labelHeight(height: 50, cornerRadius: 8)
        
        return label
    }()
    
    weak var quizManagementViewDelegate:QuizManagementViewDelegate?
    
    // MARK: Init
    
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
        
        
        if self.quizModel?.count == 0 {
            setNoneLabel()
        }
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if noneLabel.isDescendant(of: self) {
            noneLabel.removeFromSuperview()
        }
        
        let cell:QuizListCell = tableView.dequeueReusableCell(withIdentifier: "quizCell") as! QuizListCell
        cell.setCell(
            listValue: ListValue(title: "問題\(indexPath.row + 1)", value: (quizModel?[indexPath.row].quizTitle)!), displaySwitch: (quizModel?[indexPath.row].displayFlag)!)
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
    
    
    private func setNoneLabel(){
        addSubview(noneLabel)
        
        noneLabel.translatesAutoresizingMaskIntoConstraints = false
        noneLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        noneLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        noneLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        noneLabel.heightAnchor.constraint(equalToConstant: noneLabel.bounds.height).isActive = true
    }
    
}



// MARK: - QuizListCell

fileprivate final class QuizListCell:UITableViewCell {
    
    // MARK: Properties
    
    let quizNoLabel:UILabel = UILabel(title: nil,
                                      font: UIFont.systemFont(ofSize: 18),
                                      textColor: .black,
                                      backgroundColor: .clear,
                                      textAlignment: .left,
                                      numberOfLines: 1
    )
    let quizTitleLabel:UILabel = UILabel(title: nil,
                                         font: UIFont.systemFont(ofSize: 19),
                                         textColor: .black,
                                         backgroundColor: .clear,
                                         textAlignment: .left,
                                         numberOfLines: 0
    )
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont.systemFont(ofSize: 18)
        textLabel?.textColor = .black
        textLabel?.backgroundColor = .clear
        textLabel?.textAlignment = .left
        textLabel?.numberOfLines = 1
        
        detailTextLabel?.font = UIFont.systemFont(ofSize: 19)
        detailTextLabel?.textColor = .black
        detailTextLabel?.backgroundColor = .clear
        detailTextLabel?.textAlignment = .left
        detailTextLabel?.numberOfLines = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: InternalFunc
    
    
    func setCell(listValue: ListValue, displaySwitch: String){
        textLabel?.text = listValue.title
        textLabel?.accessibilityIdentifier = listValue.title
        
        detailTextLabel?.text = listValue.value
        if displaySwitch == "1" {
            self.backgroundColor = .lightGray
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.backgroundColor = .white
    }
    
}


protocol ListProtocol {
    var title: String { get }
    var value: String { get }
}

struct ListValue: ListProtocol {
    var title: String
    var value: String
}


