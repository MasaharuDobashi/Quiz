//
//  quizEditView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/28.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

class QuizEditView: UITableView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: Properties
    
    private var quizModel:[QuizModel]?
    private var mode:ModeEnum!
    
    let titleTextField:UITextField = UITextField()
    let true_TextField:UITextField = UITextField()
    let false1_TextField:UITextField = UITextField()
    let false2_textField:UITextField = UITextField()
    let false3_textField:UITextField = UITextField()
    let displaySwitch: UISwitch = UISwitch()
    
    
    
    // MARK: Init
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
    }
    
    /// add Init
    convenience init(frame: CGRect, style: UITableView.Style, mode:ModeEnum) {
        self.init(frame: frame, style: style)
        self.mode = mode
    }
    
    
    /// edit,detail Init
    convenience init(frame: CGRect, style: UITableView.Style, quizModel: [QuizModel]?, mode:ModeEnum) {
        self.init(frame: frame, style: style)
        self.quizModel = quizModel
        self.mode = mode
        
        
        if mode != .add {
            titleTextField.text = quizModel![0].quizTitle
            true_TextField.text = quizModel![0].trueAnswer
            false1_TextField.text = quizModel![0].falseAnswer1
            false2_textField.text = quizModel![0].falseAnswer2
            false3_textField.text = quizModel![0].falseAnswer3
            displaySwitch.isOn = quizModel![0].displayFlag == "0" ? true : false
            
            
            if mode == .detail {
                titleTextField.isEnabled = false
                true_TextField.isEnabled = false
                false1_TextField.isEnabled = false
                false2_textField.isEnabled = false
                false3_textField.isEnabled = false
                displaySwitch.isEnabled = false
            }
        }
        
    }
    
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        
        
        switch indexPath.section {
        case 0:
            titleTextField.accessibilityIdentifier = "title"
            titleTextField.placeholder = "クイズのタイトルを入力してください。"
            setTextFieldAutoLayout(textField: titleTextField, cell: cell)
        case 1:
            true_TextField.accessibilityIdentifier = "true"
            true_TextField.placeholder = "正解の回答を入力してください。"
            setTextFieldAutoLayout(textField: true_TextField, cell: cell)
        case 2:
            false1_TextField.accessibilityIdentifier = "false1"
            false1_TextField.placeholder = "不正解の回答を入力してください。"
            setTextFieldAutoLayout(textField: false1_TextField, cell: cell)
        case 3:
            false2_textField.accessibilityIdentifier = "false2"
            false2_textField.placeholder = "不正解の回答を入力してください。"
            setTextFieldAutoLayout(textField: false2_textField, cell: cell)
        case 4:
            false3_textField.accessibilityIdentifier = "false3"
            false3_textField.placeholder = "不正解の回答を入力してください。"
            setTextFieldAutoLayout(textField: false3_textField, cell: cell)
        case 5:
            displaySwitch.accessibilityIdentifier = "switch"
            mode == .add ? displaySwitch.isOn = true : nil
            cell.textLabel?.text = " 表示・非表示"
            cell.contentView.addSubview(displaySwitch)
            displaySwitch.translatesAutoresizingMaskIntoConstraints = false
            displaySwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20).isActive = true
            displaySwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
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
        case 5:
            headerLabel.text = "表示"
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
        return section == 0 ? 40 : 30
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == tableView.numberOfSections - 1 ? 350 : CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    // MARK: Other
    
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
