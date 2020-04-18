//
//  quizEditView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/28.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

final class QuizEditView: UITableView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Properties
    
    /// クイズを格納する
    private var quizModel: QuizModel?
    
    /// クイズタイプを格納する
    var quizTypeModel: [QuizTypeModel]?
    
    /// クイズのカテゴリのIDを格納する
    var typeid: String?
    
    /// 新規追加、編集、詳細の判別
    private var mode: ModeEnum!
    
    /// タイトル入力テキストフィールド
    private lazy var titleTextField: UITextField = UITextField()
    
    /// 正解入力テキストフィールド
    private lazy var true_TextField: UITextField = UITextField()
    
    /// 不正解1入力テキストフィールド
    private lazy var false1_TextField: UITextField = UITextField()
    
    /// 不正解2入力テキストフィールド
    private lazy var false2_textField: UITextField = UITextField()
    
    /// 不正解3入力テキストフィールド
    private lazy var false3_textField: UITextField = UITextField()
    
    /// クイズのタイプ選択
    private lazy var quizTypeTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.inputView = quizTypePicker
        
        return textField
    }()
    
    
    lazy var quizTypePicker: UIPickerView = {
        let picker: UIPickerView = UIPickerView()
        picker.delegate = self
        
        return picker
    }()
    
    /// 表示・非表示選択スイッチ
    private lazy var displaySwitch: UISwitch = {
        let switchView:UISwitch = UISwitch()
        mode == .add ? switchView.isOn = true : nil
        
        return switchView
    }()
    
    
    
    // MARK: Init
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.allowsSelection = false
    }
    
    /// add Init
    convenience init(frame: CGRect, style: UITableView.Style, mode:ModeEnum) {
        self.init(frame: frame, style: style)
        self.mode = mode
    }
    
    
    /// edit,detail Init
    convenience init(frame: CGRect, style: UITableView.Style, quizModel: QuizModel?, mode:ModeEnum) {
        self.init(frame: frame, style: style)
        self.quizModel = quizModel
        self.mode = mode
        
        
        if mode != .add {
            titleTextField.text = quizModel?.quizTitle
            true_TextField.text = quizModel?.trueAnswer
            false1_TextField.text = quizModel?.falseAnswer1
            false2_textField.text = quizModel?.falseAnswer2
            false3_textField.text = quizModel?.falseAnswer3
            quizTypeTextField.text = quizModel?.quizTypeModel?.quizTypeTitle
            displaySwitch.isOn = quizModel?.displayFlag == "0" ? true : false
            
            
            if mode == .detail {
                titleTextField.isEnabled = false
                true_TextField.isEnabled = false
                false1_TextField.isEnabled = false
                false2_textField.isEnabled = false
                false3_textField.isEnabled = false
                quizTypeTextField.isEnabled = false
                displaySwitch.isEnabled = false
            }
        }
        
    }
    
    let toolBar: UIToolbar = {
        let toolBar: UIToolbar = UIToolbar()
        let toolButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toolBarButtonTapAction))
        let spaceToolButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.bounds.size = CGSize(width: UIScreen.main.bounds.width, height: 50)
        toolBar.items = [spaceToolButton, spaceToolButton, toolButton]
        
        return toolBar
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc func toolBarButtonTapAction(_: UIBarButtonItem) {
        endEditing(true)
    }
    
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return InputType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    
    // MARK: Cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        cell.backgroundColor = R.color.cellWhite
        
        guard let rowEditValue:RowEditValue = InputType(rawValue: indexPath.section)?.rowEditValue else { return cell }
        
        switch indexPath.section {
        case InputType.title.rawValue:
            titleTextField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            titleTextField.placeholder = rowEditValue.placeholder
            setTextFieldConstraint(textField: titleTextField, cell: cell)
            
        case InputType.correctAnswer.rawValue:
            true_TextField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            true_TextField.placeholder = rowEditValue.placeholder
            setTextFieldConstraint(textField: true_TextField, cell: cell)
            
        case InputType.incorrectAnswer1.rawValue:
            false1_TextField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            false1_TextField.placeholder = rowEditValue.placeholder
            setTextFieldConstraint(textField: false1_TextField, cell: cell)
            
        case InputType.incorrectAnswer2.rawValue:
            false2_textField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            false2_textField.placeholder = rowEditValue.placeholder
            setTextFieldConstraint(textField: false2_textField, cell: cell)
            
        case InputType.incorrectAnswer3.rawValue:
            false3_textField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            false3_textField.placeholder = rowEditValue.placeholder
            setTextFieldConstraint(textField: false3_textField, cell: cell)
            
        case InputType.quizType.rawValue:
            if quizTypeModel?.count == 0 { return UITableViewCell() }
            
            quizTypeTextField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            quizTypeTextField.placeholder = rowEditValue.placeholder
            setTextFieldConstraint(textField: quizTypeTextField, cell: cell)
            
        case InputType.showHide.rawValue:
            displaySwitch.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            cell.textLabel?.text = rowEditValue.placeholder
            
            cell.addSubview(displaySwitch)
            displaySwitch.translatesAutoresizingMaskIntoConstraints = false
            displaySwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20).isActive = true
            displaySwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            
        default:
            break
        }

        
        return cell
    }
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if InputType.quizType.rawValue == indexPath.section {
            if quizTypeModel?.count == 0 { return CGFloat.leastNormalMagnitude }
        }
        
        return 50
    }
    
    // MARK: Header
    
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
        if InputType.quizType.rawValue == section {
            if quizTypeModel?.count == 0 { return CGFloat.leastNormalMagnitude }
        }
        return section == InputType.title.rawValue ? 40 : 30
    }
    
    
    
    // MARK: Footer
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if InputType.quizType.rawValue == section {
            if quizTypeModel?.count == 0 { return CGFloat.leastNormalMagnitude }
        }
        
        return section == InputType.showHide.rawValue ? 400 : CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    
    
    
    // MARK: UIPickerViewDelegate, UIPickerViewDataSource
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quizTypeModel!.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return quizTypeModel?[row].quizTypeTitle
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        quizTypeTextField.text = quizTypeModel?[row].quizTypeTitle
        typeid = (quizTypeModel?[row].id)!
    }
    
    
    
    
    
    // MARK: Other
    
    private func setTextFieldConstraint(textField: UITextField, cell:UITableViewCell) {
        textField.inputAccessoryView = toolBar
        textField.delegate = self
        textField.textAlignment = .left
        cell.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20).isActive = true
        textField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
    }
    
    
    func getParameters() -> [String: Any] {
        let key:ParameterKey = ParameterKey()
        let parameters: [String: Any] = [key.title: titleTextField.text ?? "",
                                        key.correctAnswer: true_TextField.text ?? "",
                                        key.incorrectAnswer1: false1_TextField.text ?? "",
                                        key.incorrectAnswer2: false2_textField.text ?? "",
                                        key.incorrectAnswer3: false3_textField.text ?? "",
                                        key.quizType: typeid ?? "",
                                        key.displayFlag: displaySwitch.isOn == true ? "0" : "1"
                                        ]
        
        
        return parameters
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
        case quizType
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
            case .quizType:
                return QuizType()
            case .showHide:
                return ShowHide()
            }
        }
        
        private struct Title: RowEditValue {
            let placeholder: String = "クイズのタイトルを入力してください。"
            let accessibilityIdentifier: String = "title"
            let headerTitle: String = "タイトル"
        }
        
        private struct CorrectAnswer: RowEditValue {
            let placeholder: String = "正解の回答を入力してください。"
            let accessibilityIdentifier: String = "correctAnswer"
            let headerTitle: String = "正解"
        }
        
        private struct IncorrectAnswer1: RowEditValue {
            let placeholder: String = "不正解の回答を入力してください。"
            let accessibilityIdentifier: String  = "incorrectAnswer1"
            let headerTitle: String = "不正解1"
        }
        
        private struct IncorrectAnswer2: RowEditValue {
            var placeholder: String = "不正解の回答を入力してください。"
            var accessibilityIdentifier: String  = "incorrectAnswer2"
            var headerTitle: String = "不正解2"
        }
        
        private struct IncorrectAnswer3: RowEditValue {
            let placeholder: String = "不正解の回答を入力してください。"
            let accessibilityIdentifier: String  = "incorrectAnswer3"
            let headerTitle: String = "不正解3"
        }
        
        private struct QuizType: RowEditValue {
            let placeholder: String = " クイズのカテゴリを選択してください"
            let accessibilityIdentifier: String = "quizType"
            let headerTitle: String = "クイズのカテゴリ"
        }
        
        private struct ShowHide: RowEditValue {
            let placeholder: String = " 表示・非表示"
            let accessibilityIdentifier: String = "showHide"
            let headerTitle: String = "表示"
        }
    }
}


struct ParameterKey {
    let title: String = "title"
    let correctAnswer: String = "correctAnswer"
    let incorrectAnswer1: String = "incorrectAnswer1"
    let incorrectAnswer2: String = "incorrectAnswer2"
    let incorrectAnswer3: String = "incorrectAnswer3"
    let quizType: String = "quizType"
    let displayFlag: String = "displayFlag"
}
