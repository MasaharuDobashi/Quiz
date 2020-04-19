//
//  HistoryView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/06/11.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import LineGraphView
import RealmSwift



final class HistoryView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    private let screenWidth = UIScreen.main.bounds.width
    private var historyModel: Results<HistoryModel>!
    private var trueCounts:[Int]!
    
    
    private lazy var totalsTable: UITableView = {
        let tableView:UITableView = UITableView()
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "historyCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    
    private lazy var lineGraphView:LineGraphView = {
        let view:LineGraphView = LineGraphView(graphHeight: 290, values: trueCounts,
                                               lineOptions: .init(strokeWidth: 3,
                                                                  strokeColor: R.color.Rubyred),
                                               lineAnimationOptions: .init(isAnime: true, duration: Double(trueCounts.count) / 10)
        )
        
        view.backgroundColor = UIColor.changeAppearnceColor(light: .white, dark: .darkGray)
        view.valueLabelOption?.labelBackgroundColor = UIColor.changeAppearnceColor(light: .white, dark: .darkGray)
        view.ruledLine(lineWidth: screenWidth * 0.9)
        
        return view
    }()
    

    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.color.Beige
    }
    
    convenience init(frame: CGRect, historyModel model: Results<HistoryModel>!) {
        self.init(frame: frame)
        historyModel = model
        trueCounts = [Int]()
        
        for i in 0..<historyModel.count {
            let count:Int = Int(historyModel[i].quizTrueCount)!
            trueCounts.append(Int(count))
        }
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewLoad
    
    private func viewLoad(){
        addSubview(lineGraphView)
        addSubview(totalsTable)
        
        setConstraint()
    }
    
    
    
    /// 制約を付ける
    private func setConstraint(){
        lineGraphView.translatesAutoresizingMaskIntoConstraints = false
        lineGraphView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        lineGraphView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lineGraphView.widthAnchor.constraint(equalToConstant: screenWidth * 0.9).isActive = true
        lineGraphView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        totalsTable.translatesAutoresizingMaskIntoConstraints = false
        totalsTable.topAnchor.constraint(equalTo: lineGraphView.bottomAnchor, constant: 10).isActive = true
        totalsTable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        totalsTable.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        totalsTable.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    
    /// lineGraphViewのアニメーションを呼ぶ
    func lineAnimetion(){
        lineGraphView.setLineGraph()
    }
    
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let historyCell: HistoryCell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryCell
        
        historyCell.setValue(listValue: ListValue(title: historyModel[indexPath.row].date, value: historyModel[indexPath.row].quizTrueCount))
        return historyCell
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
}









// MARK: - HistoryCell

fileprivate final class HistoryCell: UITableViewCell {
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = R.color.cellWhite
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// セルのテキストをセットする
    /// - Parameter listValue: title: 日付, value: 正解数
    func setValue(listValue: ListValue){
        textLabel?.text = delete_sec(listValue.title)
        detailTextLabel?.text = listValue.value + "問"
    }
    
    
    
    /// 秒数の部分を削除する
    private func delete_sec(_ str: String) -> String {
        /// 履歴の時間を秒数までの保存に変更したが、表示するのは分までなので秒数を削って表示する
        if str.count == "yyyy/MM/dd HH:mm:ss".count {
            return String(str.prefix(str.count - 3))
        } else {
            return str
        }
        
    }
}
