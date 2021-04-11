//
//  quizEditViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/28.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

final class QuizEditViewController: UIViewController {

    // MARK: Properties

    /// クイズのID
    private var quiz_id: String = ""

    private var createTime: String?

    /// 新規追加、編集、詳細の判別
    private var mode = ModeEnum.add

    /// クイズを格納
    private var quizModel: QuizModel!

    ///  カテゴリを格納
    private var quizCategoryModel: [QuizCategoryModel]!

    /// クイズの編集画面
    private var quizEditView: QuizEditView!

    // MARK: Init

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    /// add Init
    convenience init(mode: ModeEnum) {
        self.init(nibName: nil, bundle: nil)
        self.mode = mode
    }

    /// edit,detail Init
    convenience init(quzi_id: String, createTime: String?, mode: ModeEnum) {
        self.init(nibName: nil, bundle: nil)
        self.quiz_id = quzi_id
        self.createTime = createTime
        self.mode = mode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem()
        initQuizEditView()
    }

    /// QuizEditViewの初期化
    private func initQuizEditView() {
        switch mode {
        case .add:
            quizEditView = QuizEditView(frame: frame, style: .grouped, mode: mode)
        case .edit, .detail:
            quizModelAppend()
            quizEditView = QuizEditView(frame: frame, style: .grouped, quizModel: quizModel, mode: mode)
            debugPrint(object: quizModel)
        }
        quizEditView.quizTypeModel = QuizCategoryModel.findAllQuizCategoryModel(self)
        view.addSubview(quizEditView)
    }

    // MARK: NavigationItem Func

    override func setNavigationBarItem() {
        super.setNavigationBarItem()
        if mode == .detail {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(detailRightButtonAction))
        }
    }

    override func rightNaviBarButtonAction() {
        if validate() == false { return }

        realmAction {
            postNotificationCenter()
        }
    }

    @objc func detailRightButtonAction() {
        AlertManager().createActionSheet(self, message: R.string.messages.quizActionSheetMessage(), didTapEditButton: { [weak self] _ in
            self?.pushTransition(QuizEditViewController(quzi_id: self?.quizModel.id ?? "", createTime: self?.quizModel.createTime ?? "", mode: .edit))

        }, didTapDeleteButton: { _ in
            self.deleteQuiz { [weak self] in
                self?.leftNaviBarButtonAction()
            }
        })
    }

    // MARK: Realm Func

    private func realmAction(completion: () -> Void) {

        if mode == .add {
            addRealm {
                AlertManager().alertAction( self, title: nil, message: R.string.messages.quizAdd(), didTapCloseButton: { [weak self] _ in
                    self?.leftNaviBarButtonAction()
                })
            }
        } else if mode == .edit {
            updateRealm {
                AlertManager().alertAction(self, title: nil, message: R.string.messages.quizEdit(), didTapCloseButton: { [weak self] _ in
                    self?.leftNaviBarButtonAction()
                })
            }
        }

        completion()

    }

    /// Realmに新規追加
    private func addRealm(completion: () -> Void) {
        QuizModel.addQuiz(self,
                          title: quizEditView.title_text,
                          correctAnswer: quizEditView.true_text,
                          incorrectAnswer1: quizEditView.false1_text,
                          incorrectAnswer2: quizEditView.false2_text,
                          incorrectAnswer3: quizEditView.false3_text,
                          displayFlag: quizEditView.isDisplay ? DisplayFlg.indicated.rawValue : DisplayFlg.nonIndicated.rawValue,
                          quizType: quizEditView.typeid ?? ""
        )
        completion()
    }

    /// アップデート
    private func updateRealm(completion: () -> Void) {
        QuizModel.updateQuiz(self,
                             id: quiz_id,
                             createTime: createTime,
                             title: quizEditView.title_text,
                             correctAnswer: quizEditView.true_text,
                             incorrectAnswer1: quizEditView.false1_text,
                             incorrectAnswer2: quizEditView.false2_text,
                             incorrectAnswer3: quizEditView.false3_text,
                             displayFlag: quizEditView.isDisplay ? DisplayFlg.indicated.rawValue : DisplayFlg.nonIndicated.rawValue,
                             quizType: quizEditView.typeid ?? ""
        )
        completion()
    }

    /// クイズの削除
    private func deleteQuiz(completion: () -> Void) {
        QuizModel.deleteQuiz(self, id: quizModel.id, createTime: quizModel.createTime ?? "")
        completion()
    }

    /// クイズを一件取得
    private func quizModelAppend() {
        quizModel = QuizModel.findQuiz(self, quizid: quiz_id, createTime: createTime)
    }

    // MARK: Other

    /// 各項目のバリデーションを実施
    private func validate() -> Bool {

        if emptyValidate(viewController: self, title: quizEditView.title_text, message: R.string.messages.validateTitle()) == false {
            return false
        }

        if emptyValidate(viewController: self, title: quizEditView.true_text, message: R.string.messages.validateCorrectAnswer()) == false {
            return false
        }
        if emptyValidate(viewController: self, title: quizEditView.false1_text, message: R.string.messages.validateIncorrectAnswer("1")) == false {
            return false
        }
        if emptyValidate(viewController: self, title: quizEditView.false2_text, message: R.string.messages.validateIncorrectAnswer("2")) == false {
            return false
        }
        if emptyValidate(viewController: self, title: quizEditView.false3_text, message: R.string.messages.validateIncorrectAnswer("3")) == false {
            return false
        }

        if QuizCategoryModel.findAllQuizCategoryModel(self).count > 0 {
            if emptyValidate(viewController: self,
                             title: quizEditView.typeid ?? "",
                             message: R.string.messages.validateCategory()) == false {
                return false
            }
        }
        return true
    }

    private func postNotificationCenter() {
        NotificationCenter.default.post(name: Notification.Name(R.string.notifications.quizUpdate()), object: nil)
    }

}
