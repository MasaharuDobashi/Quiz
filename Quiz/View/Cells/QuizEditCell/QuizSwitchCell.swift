//
//  QuizSwitchCell.swift
//  Quiz
//
//  Created by 土橋正晴 on 2021/03/21.
//  Copyright © 2021 m.dobashi. All rights reserved.
//

import UIKit

class QuizSwitchCell: UITableViewCell {

    @IBOutlet weak var placeholderLabel: UILabel!

    @IBOutlet weak var displaySwitch: UISwitch!

    func setValue(label: String, isDisplay: Bool, accessibilityIdentifier: String) {
        placeholderLabel.text = label
        displaySwitch.isOn = isDisplay
        displaySwitch.accessibilityIdentifier = accessibilityIdentifier
    }

}
