//
//  QuizTypeEditView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/11/04.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

final class QuizTypeEditView: UITableView, UITableViewDelegate, UITableViewDataSource {

    private var typeLabel: UILabel = {
        let label = UILabel(title: "クイズのカテゴリ")
        label.sizeToFit()

        return label
    }()

    lazy var typeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "クイズのカテゴリを入力してください"

        return textField
    }()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }

    /// edit,detail Init
    convenience init(frame: CGRect, style: UITableView.Style, mode: ModeEnum) {
        self.init(frame: frame, style: style)

        delegate = self
        dataSource = self
        allowsSelection = false
        separatorInset = .zero

        if mode == .detail {
            typeTextField.isEnabled = false
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UITableViewDelegate, UITableViewDataSource

    override func numberOfRows(inSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    // MARK: Cell

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.contentView.addSubview(typeTextField)

        typeTextField.translatesAutoresizingMaskIntoConstraints = false
        typeTextField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        typeTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20).isActive = true
        typeTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20).isActive = true
        typeTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }

    // MARK: Header

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()

        headerLabel.text = "クイズのカテゴリ"
        headerLabel.accessibilityIdentifier = "quizTypeLabel"
        headerView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }

}
