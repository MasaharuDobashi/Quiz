//
//  quizEditView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/28.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

class QuizEditView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    private let realm:Realm = try! Realm()
    private var quizModel:QuizModel = QuizModel()
    private var quiz_id:Int?
    let titleTextField:UITextField = UITextField()
    let true_TextField:UITextField = UITextField()
    let false1_TextField:UITextField = UITextField()
    let false2_textField:UITextField = UITextField()
    let false3_textField:UITextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewload()
    }
    
    
    convenience init(frame: CGRect, quiz_id: Int?) {
        self.init(frame: frame)
        self.quiz_id = quiz_id
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func viewload(){
        let tableView:UITableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        
        if quiz_id != nil {
            titleTextField.text = realm.objects(QuizModel.self)[quiz_id!].quizTitle
            true_TextField.text = realm.objects(QuizModel.self)[quiz_id!].trueAnswer
            false1_TextField.text = realm.objects(QuizModel.self)[quiz_id!].falseAnswer1
            false2_textField.text = realm.objects(QuizModel.self)[quiz_id!].falseAnswer2
            false3_textField.text = realm.objects(QuizModel.self)[quiz_id!].falseAnswer3
        }
        
        
        switch indexPath.section {
        case 0:
            titleTextField.placeholder = "クイズのタイトルを入力してください。"
            setTextFieldAutoLayout(textField: titleTextField, cell: cell)
        case 1:
            true_TextField.placeholder = "正解の回答を入力してください。"
            setTextFieldAutoLayout(textField: true_TextField, cell: cell)
        case 2:
            false1_TextField.placeholder = "不正解の回答を入力してください。"
            setTextFieldAutoLayout(textField: false1_TextField, cell: cell)
        case 3:
            false2_textField.placeholder = "不正解の回答を入力してください。"
            setTextFieldAutoLayout(textField: false2_textField, cell: cell)
        case 4:
            false3_textField.placeholder = "不正解の回答を入力してください。"
            setTextFieldAutoLayout(textField: false3_textField, cell: cell)
        default:
            break
        }

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView = UIView()
        let headerLabel:UILabel = UILabel()
        
        switch section {
        case 0:
            headerLabel.text = "タイトル"
        case 1:
            headerLabel.text = "正解"
        case 2:
            headerLabel.text = "不正解1"
        case 3:
            headerLabel.text = "不正解2"
        case 4:
            headerLabel.text = "不正解3"
        default:
            break
        }
        headerView.addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 40 : 20
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    // MARK: - Realm func
    
    func addRealm(){
        quizModel.id = String(realm.objects(QuizModel.self).count)
        quizModel.quizTitle = titleTextField.text!
        quizModel.trueAnswer = true_TextField.text!
        quizModel.falseAnswer1 = false1_TextField.text!
        quizModel.falseAnswer2 = false2_textField.text!
        quizModel.falseAnswer3 = false3_textField.text!
        
        
        try! realm.write() {
            realm.add(quizModel)
        }
    }
    
    
    
    func updateRealm(){        
        try! realm.write() {
            realm.objects(QuizModel.self)[quiz_id!].quizTitle = titleTextField.text!
            realm.objects(QuizModel.self)[quiz_id!].trueAnswer = true_TextField.text!
            realm.objects(QuizModel.self)[quiz_id!].falseAnswer1 = false1_TextField.text!
            realm.objects(QuizModel.self)[quiz_id!].falseAnswer2 = false2_textField.text!
            realm.objects(QuizModel.self)[quiz_id!].falseAnswer3 = false3_textField.text!
        }
    }
    
    
    private func setTextFieldAutoLayout(textField: UITextField, cell:UITableViewCell){
        textField.delegate = self
        cell.contentView.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20).isActive = true
        textField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
    }
}
