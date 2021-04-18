//
//  quizEditView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/28.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

final class QuizEditView: UITableView {

    // MARK: Properties

    /// クイズを格納する
    private var quizModel: QuizModel?

    /// クイズタイプを格納する
    var quizTypeModel: [QuizCategoryModel] = []

    /// クイズのカテゴリのIDを格納する
    var typeid: String?

    /// 新規追加、編集、詳細の判別
    private var mode: ModeEnum!

    /// タイトル
    var title_text: String = ""

    /// 正解
    var true_text: String = ""

    /// 不正解1
    var false1_text: String = ""

    /// 不正解2
    var false2_text: String = ""

    /// 不正解3
    var false3_text: String = ""

    /// カテゴリ
    private var quizTypeTitle: String?

    /// クイズの表示フラグ
    var isDisplay = true

    /// テキストフィールドに乗せるToolbar
    private let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        let toolButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toolBarButtonTapAction))
        let spaceToolButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.bounds.size = CGSize(width: UIScreen.main.bounds.width, height: 50)
        toolBar.items = [spaceToolButton, spaceToolButton, toolButton]

        return toolBar
    }()

    // MARK: Init

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initTableView()
    }

    /// add Init
    convenience init(frame: CGRect, style: UITableView.Style, mode: ModeEnum) {
        self.init(frame: frame, style: style)
        self.quizModel = QuizModel()
        self.mode = mode
    }

    /// edit,detail Init
    convenience init(frame: CGRect, style: UITableView.Style, quizModel: QuizModel, mode: ModeEnum) {
        self.init(frame: frame, style: style)
        self.title_text = quizModel.quizTitle
        self.true_text = quizModel.trueAnswer
        self.false1_text = quizModel.falseAnswer1
        self.false2_text = quizModel.falseAnswer2
        self.false3_text = quizModel.falseAnswer3
        self.quizTypeTitle = quizModel.quizTypeModel?.quizTypeTitle
        self.typeid = quizModel.quizTypeModel?.id
        self.isDisplay = quizModel.displayFlag == DisplayFlg.indicated.rawValue ? true : false
        self.mode = mode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Other

    @objc func toolBarButtonTapAction(_: UIBarButtonItem) {
        endEditing(true)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension QuizEditView: UITableViewDelegate, UITableViewDataSource {

    private func initTableView() {
        self.delegate = self
        self.dataSource = self
        self.allowsSelection = false

        register(R.nib.quizInputCell)
        register(R.nib.quizSwitchCell)
        register(R.nib.quizInputPickerCell)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        InputType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    // MARK: Cell

    // swiftlint:disable function_body_length
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        cell.backgroundColor = R.color.cellWhite()

        guard let rowEditValue: RowEditValue = InputType(rawValue: indexPath.section)?.rowEditValue else { return cell }

        switch InputType(rawValue: indexPath.section) {
        case .title:
            guard let cell: QuizInputCell = tableView.dequeueReusableCell(withIdentifier: R.nib.quizInputCell.identifier) as? QuizInputCell else {
                return UITableViewCell()
            }
            cell.setTextFieldValue(text: title_text, placeholder: rowEditValue.placeholder, toolBar: toolBar)
            cell.textField.addTarget(self, action: #selector(textFieldChangeValue), for: .editingChanged)
            cell.textField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            cell.textField.delegate = self
            if mode == .detail { cell.isUserInteractionEnabled = false }
            return cell

        case .correctAnswer:
            guard let cell: QuizInputCell = tableView.dequeueReusableCell(withIdentifier: R.nib.quizInputCell.identifier) as? QuizInputCell else {
                return UITableViewCell()
            }
            cell.setTextFieldValue(text: true_text, placeholder: rowEditValue.placeholder, toolBar: toolBar)
            cell.textField.addTarget(self, action: #selector(textFieldChangeValue), for: .editingChanged)
            cell.textField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            cell.textField.delegate = self
            if mode == .detail { cell.isUserInteractionEnabled = false }
            return cell

        case .incorrectAnswer1:
            guard let cell: QuizInputCell = tableView.dequeueReusableCell(withIdentifier: R.nib.quizInputCell.identifier) as? QuizInputCell else {
                return UITableViewCell()
            }
            cell.setTextFieldValue(text: false1_text, placeholder: rowEditValue.placeholder, toolBar: toolBar)
            cell.textField.addTarget(self, action: #selector(textFieldChangeValue), for: .editingChanged)
            cell.textField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            cell.textField.delegate = self
            if mode == .detail { cell.isUserInteractionEnabled = false }
            return cell

        case .incorrectAnswer2:
            guard let cell: QuizInputCell = tableView.dequeueReusableCell(withIdentifier: R.nib.quizInputCell.identifier) as? QuizInputCell else {
                return UITableViewCell()
            }
            cell.setTextFieldValue(text: false2_text, placeholder: rowEditValue.placeholder, toolBar: toolBar)
            cell.textField.addTarget(self, action: #selector(textFieldChangeValue), for: .editingChanged)
            cell.textField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            cell.textField.delegate = self
            if mode == .detail { cell.isUserInteractionEnabled = false }
            return cell

        case .incorrectAnswer3:
            guard let cell: QuizInputCell = tableView.dequeueReusableCell(withIdentifier: R.nib.quizInputCell.identifier) as? QuizInputCell else {
                return UITableViewCell()
            }
            cell.setTextFieldValue(text: false3_text, placeholder: rowEditValue.placeholder, toolBar: toolBar)
            cell.textField.addTarget(self, action: #selector(textFieldChangeValue), for: .editingChanged)
            cell.textField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            cell.textField.delegate = self
            if mode == .detail { cell.isUserInteractionEnabled = false }
            return cell

        case .quizType:
            guard let cell: QuizInputPickerCell = tableView.dequeueReusableCell(withIdentifier: R.nib.quizInputPickerCell.identifier) as? QuizInputPickerCell else {
                return UITableViewCell()
            }
            cell.setTextFieldValue(text: quizTypeTitle, placeholder: rowEditValue.placeholder, toolBar: toolBar)
            cell.setPickerView(quizTypeModel: quizTypeModel)
            cell.categoryDelegate = self
            cell.textField.addTarget(self, action: #selector(textFieldChangeValue), for: .editingChanged)
            cell.textField.accessibilityIdentifier = rowEditValue.accessibilityIdentifier
            cell.textField.delegate = self
            if mode == .detail { cell.isUserInteractionEnabled = false }
            return cell

        case .showHide:
            guard let cell: QuizSwitchCell = tableView.dequeueReusableCell(withIdentifier: R.nib.quizSwitchCell.identifier) as? QuizSwitchCell else {
                return UITableViewCell()
            }
            cell.setValue(label: rowEditValue.placeholder, isDisplay: isDisplay, accessibilityIdentifier: rowEditValue.accessibilityIdentifier)
            cell.displaySwitch.addTarget(self, action: #selector(displaySwitch(_:)), for: .valueChanged)
            if mode == .detail { cell.isUserInteractionEnabled = false }
            return cell

        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if InputType.quizType.rawValue == indexPath.section {
            if quizTypeModel.count == 0 { return CGFloat.leastNormalMagnitude }
        }

        return 50
    }

    // MARK: Header

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()

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
            if quizTypeModel.count == 0 { return CGFloat.leastNormalMagnitude }
        }
        return section == InputType.title.rawValue ? 40 : 30
    }

    // MARK: Footer

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if InputType.quizType.rawValue == section {
            if quizTypeModel.count == 0 { return CGFloat.leastNormalMagnitude }
        }

        return section == InputType.showHide.rawValue ? 400 : CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

}

// MARK: - UITextFieldDelegate, UITextField

extension QuizEditView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    @objc func textFieldChangeValue(textField: UITextField) {
        switch textField.accessibilityIdentifier {
        case InputType.title.rowEditValue.accessibilityIdentifier:
            title_text = textField.text ?? ""
        case InputType.correctAnswer.rowEditValue.accessibilityIdentifier:
            true_text = textField.text ?? ""
        case InputType.incorrectAnswer1.rowEditValue.accessibilityIdentifier:
            false1_text = textField.text ?? ""
        case InputType.incorrectAnswer2.rowEditValue.accessibilityIdentifier:
            false2_text = textField.text ?? ""
        case InputType.incorrectAnswer3.rowEditValue.accessibilityIdentifier:
            false3_text = textField.text ?? ""
        case InputType.quizType.rowEditValue.accessibilityIdentifier:
            break
        default:
            break
        }
    }

}

extension QuizEditView: QuizInputPickerCellDeleagte {
    func categoryChange(category_id: String) {
        typeid = category_id
    }

}

// MARK: - UISwitch

extension QuizEditView {

    @objc private func displaySwitch(_ sender: UISwitch) {
        isDisplay = sender.isOn
    }

}

// MARK: - RowEditValue

protocol RowEditValue {
    var placeholder: String { get }
    var accessibilityIdentifier: String { get }
    var headerTitle: String { get }
}

// MARK: - Other

extension QuizEditView {

    enum InputType: Int, CaseIterable {
        /// タイトル
        case title
        /// 正解
        case correctAnswer
        /// 不正解1
        case incorrectAnswer1
        /// 不正解2
        case incorrectAnswer2
        /// 不正解3
        case incorrectAnswer3
        /// カテゴリ
        case quizType
        /// 表示フラグ
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
            let accessibilityIdentifier: String = "incorrectAnswer1"
            let headerTitle: String = "不正解1"
        }

        private struct IncorrectAnswer2: RowEditValue {
            var placeholder: String = "不正解の回答を入力してください。"
            var accessibilityIdentifier: String = "incorrectAnswer2"
            var headerTitle: String = "不正解2"
        }

        private struct IncorrectAnswer3: RowEditValue {
            let placeholder: String = "不正解の回答を入力してください。"
            let accessibilityIdentifier: String = "incorrectAnswer3"
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
