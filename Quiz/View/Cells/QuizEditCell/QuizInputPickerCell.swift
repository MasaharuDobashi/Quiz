//
//  QuizInputPickerCell.swift
//  Quiz
//
//  Created by 土橋正晴 on 2021/04/15.
//  Copyright © 2021 m.dobashi. All rights reserved.
//

import UIKit

protocol QuizInputPickerCellDeleagte: AnyObject {
    func categoryChange(category_id: String)
}

/// テキストフィールドにカテゴリをピッカーで選択するセル
class QuizInputPickerCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!

    /// カテゴリ選択Picker
    private var quizTypePicker: UIPickerView?

    /// クイズタイプを格納する
    private var quizTypeModel: [QuizCategoryModel] = []

    weak var categoryDelegate: QuizInputPickerCellDeleagte!

    func setTextFieldValue(text: String?, placeholder: String, toolBar: UIToolbar) {
        textField.text = text
        textField.placeholder = placeholder
        textField.inputAccessoryView = toolBar
    }

    func setPickerView(quizTypeModel: [QuizCategoryModel]) {
        self.quizTypeModel = quizTypeModel
        if self.quizTypeModel.count == 0 {
            isUserInteractionEnabled = false
            return
        }
        quizTypePicker = UIPickerView()
        textField.inputView = quizTypePicker
        quizTypePicker?.delegate = self
    }

}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension QuizInputPickerCell: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        quizTypeModel.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        quizTypeModel[row].quizTypeTitle
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = quizTypeModel[row].quizTypeTitle
        categoryDelegate.categoryChange(category_id: quizTypeModel[row].id)
    }

}
