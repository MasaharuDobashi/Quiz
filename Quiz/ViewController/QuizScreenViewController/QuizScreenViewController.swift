//
//  QuizScreenViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

class QuizScreenViewController: UIViewController, QuizScreenViewDelagate {

    // MARK: Properties

    private lazy var quizScreenView: QuizScreenView = {
        let view = QuizScreenView(frame: frame, quizModel: quizModel[quizNum])
        view.delagate = self
        return view
    }()

    /// クイズを格納する配列
    private var quizModel: [QuizModel] = []

    /// 何問目かを格納
    var quizNum: Int = 0

    /// 正解数を格納
    var trueConunt: Int = 0

    /// クイズの選択があるかのフラグ
    var quizSelect: QuizSelect?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftNaviBarButtonAction))
        quizModelAppend()
        quizActiveCheck()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if quizModel.count == 0 {
            return
        }

        debugPrint(object: quizModel[quizNum])

        quizScreenView.quizModel = quizModel[quizNum]
        quizScreenView.quizChange()
    }

    // MARK: Private Func

    /// 表示するクイズを配列に格納する
    private func quizModelAppend() {
        quizModel = QuizModel.displayFindQuiz(self)
        if QuizCategoryModel.findAllQuizCategoryModel(self).isEmpty {
            /// カテゴリがなかった場合
            quizSelect = .zero
        } else {
            for _ in 0..<quizModel.count {
                /// カテゴリが選択されている
                if  QuizModel.selectQuiz(self).count > 0 && QuizModel.selectQuiz(self).count < 10 {
                    quizModel = QuizModel.selectQuiz(self)
                    quizSelect = .select
                } else {
                    /// カテゴリが作成されているが選択されていない
                    quizSelect = .notSelect
                }
            }

        }

    }

    /// クイズを開始できるかチェックする
    ///
    /// クイズを開始できる場合はquizScreenViewをaddSubViewする
    ///
    /// 開始できない場合はモーダルを閉じる
    private func quizActiveCheck() {
        view.backgroundColor = .white
        if quizModel.count == 0 {
            AlertManager().alertAction(self, title: nil, message: "利用可能なクイズがありませんでした。", didTapCloseButton: { _ in
                self.leftNaviBarButtonAction()
            })
            return
        }

        if quizModel.count > 10 {
            AlertManager().alertAction(self, title: "利用可能なクイズが10問を超えています。", message: "編集からクイズを非表示または、削除をし１０問以下に減らして下さい。", didTapCloseButton: { _ in
                self.leftNaviBarButtonAction()
            })

        } else {

            switch quizSelect {
            case .select, .zero:
                view.addSubview(quizScreenView)

            case .notSelect:
                AlertManager().alertAction(self, title: nil, message: "選択されたクイズがありませんでした。", didTapCloseButton: {_ in
                    self.leftNaviBarButtonAction()

                })
            case .none:
                AlertManager().alertAction(self, title: nil, message: "利用可能なクイズがありませんでした。", didTapCloseButton: {_ in
                    self.leftNaviBarButtonAction()

                })
            }
        }

    }

    // MARK: QuizScreenViewDelagate Func

    /// 回答を選択した時のアクション
    ///
    /// 次の問題があれば画面を更新し次の問題を表示
    /// 問題がなければリザルト画面を表示する
    func buttonTapAction() {
        quizNum += 1
        if  quizNum < quizModel.count {
            self.viewWillAppear(true)
        } else {
            let viewController = ResultScreenViewController(trueConunt: trueConunt)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    /// クイズを正解したら1プラスする
    func trueConut() {
        trueConunt += 1
    }

    // MARK: Enum

    /// カテゴリの選択状態
    enum QuizSelect: String {

        /// QuizCategoryの登録なし
        case zero = "0"

        /// QuizCategoryの登録あり、quizTypeを選択済み
        case select = "1"

        /// QuizCategoryの登録あり、quizTypeを未選択
        case notSelect = "2"
    }

}
