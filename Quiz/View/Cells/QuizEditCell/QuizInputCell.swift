//
//  QuizInputCell.swift
//  Quiz
//
//  Created by 土橋正晴 on 2021/03/21.
//  Copyright © 2021 m.dobashi. All rights reserved.
//

import UIKit

class QuizInputCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!

    func setTextFieldValue(text: String?, placeholder: String, toolBar: UIToolbar) {
        textField.text = text
        textField.placeholder = placeholder
        textField.inputAccessoryView = toolBar
    }

}
