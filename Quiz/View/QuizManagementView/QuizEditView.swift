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
        return InputType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        
        guard let rowEditValue:RowEditValue = InputType(rawValue: indexPath.section)?.rowEditValue else { return cell }
        
        switch indexPath.section {
        case InputType.title.rawValue:
            titleTextField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            titleTextField.placeholder = rowEditValue.placeholder
            setTextFieldAutoLayout(textField: titleTextField, cell: cell)
        case InputType.correctAnswer.rawValue:
            true_TextField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            true_TextField.placeholder = rowEditValue.placeholder
            setTextFieldAutoLayout(textField: true_TextField, cell: cell)
        case InputType.incorrectAnswer1.rawValue:
            false1_TextField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            false1_TextField.placeholder = rowEditValue.placeholder
            setTextFieldAutoLayout(textField: false1_TextField, cell: cell)
        case InputType.incorrectAnswer2.rawValue:
            false2_textField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            false2_textField.placeholder = rowEditValue.placeholder
            setTextFieldAutoLayout(textField: false2_textField, cell: cell)
        case InputType.incorrectAnswer3.rawValue:
            false3_textField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            false3_textField.placeholder = rowEditValue.placeholder
            setTextFieldAutoLayout(textField: false3_textField, cell: cell)
        case InputType.showHide.rawValue:
            displaySwitch.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            mode == .add ? displaySwitch.isOn = true : nil
            cell.textLabel?.text = rowEditValue.placeholder
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
        
        guard let headerTitle = InputType(rawValue: section)?.rowEditValue else { return UIView() }
        
        headerLabel.text = headerTitle.headerTitle
        headerLabel.accessibilityIdentifier = headerTitle.accessibilityIdentifier
        headerView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == InputType.title.rawValue ? 40 : 30
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == InputType.showHide.rawValue ? 350 : CGFloat.leastNormalMagnitude
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






protocol RowEditValue {
    var placeholder:String { get }
    var accessibilityIdentifier: String { get }
    var headerTitle: String { get }
}


extension QuizEditView {
    enum InputType: Int, CaseIterable {
        case title
        case correctAnswer
        case incorrectAnswer1
        case incorrectAnswer2
        case incorrectAnswer3
        case showHide
        
        
        var rowEditValue: RowEditValue {
            switch self {
            case .title:
                return Title()
            case .correctAnswer:
                return CorrectAnswer()
            case .incorrectAnswer1:
                return IncorrectAnswer1()
            case .incorrectAnswer2:
                return IncorrectAnswer2()
            case .incorrectAnswer3:
                return IncorrectAnswer3()
            case .showHide:
                return ShowHide()
            }
        }
        
        private struct Title: RowEditValue {
            var placeholder: String = "クイズのタイトルを入力してください。"
            var accessibilityIdentifier: String = "title"
            var headerTitle: String = "タイトル"
        }
        
        private struct CorrectAnswer: RowEditValue {
            var placeholder: String = "正解の回答を入力してください。"
            var accessibilityIdentifier: String = "correctAnswer"
            var headerTitle: String = "正解"
        }
        
        private struct IncorrectAnswer1: RowEditValue {
            var placeholder: String = "不正解の回答を入力してください。"
            var accessibilityIdentifier: String  = "incorrectAnswer1"
            var headerTitle: String = "不正解1"
        }
        
        private struct IncorrectAnswer2: RowEditValue {
            var placeholder: String = "不正解の回答を入力してください。"
            var accessibilityIdentifier: String  = "incorrectAnswer2"
            var headerTitle: String = "不正解2"
        }
        
        private struct IncorrectAnswer3: RowEditValue {
            var placeholder: String = "不正解の回答を入力してください。"
            var accessibilityIdentifier: String  = "incorrectAnswer3"
            var headerTitle: String = "不正解3"
        }
        
        private struct ShowHide: RowEditValue {
            var placeholder: String = " 表示・非表示"
            var accessibilityIdentifier: String = "showHide"
            var headerTitle: String = "表示"
        }
    }
}
