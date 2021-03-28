//
//  QuizInputCell.swift
//  Quiz
//
//  Created by 土橋正晴 on 2021/03/21.
//  Copyright © 2021 m.dobashi. All rights reserved.
//

import UIKit


protocol QuizInputCellCategoryDeleagte: AnyObject {
    func categoryChange(category_id: String)
}

class QuizInputCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    /// カテゴリ選択Picker
    private var quizTypePicker: UIPickerView?
    
    /// クイズタイプを格納する
    private var quizTypeModel: [QuizCategoryModel]?
    
    weak var categoryDelegate: QuizInputCellCategoryDeleagte!
    
    
    func setTextFieldValue(text: String?, placeholder: String, toolBar: UIToolbar) {
        textField.text = text
        textField.placeholder = placeholder
        textField.inputAccessoryView = toolBar
    }
    
    
    
    func setPickerView(quizTypeModel: [QuizCategoryModel]) {
        self.quizTypeModel = quizTypeModel
        if self.quizTypeModel?.count == 0 {
            isUserInteractionEnabled = false
            return
        }
        quizTypePicker = UIPickerView()
        textField.inputView = quizTypePicker
        quizTypePicker?.delegate = self
    }
    
}



// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension QuizInputCell: UIPickerViewDelegate, UIPickerViewDataSource {
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quizTypeModel?.count ?? 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return quizTypeModel?[row].quizTypeTitle
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = quizTypeModel?[row].quizTypeTitle
        categoryDelegate.categoryChange(category_id: quizTypeModel?[row].id ?? "")
    }
    
    
    
}

