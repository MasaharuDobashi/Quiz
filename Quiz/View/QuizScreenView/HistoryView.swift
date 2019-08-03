//
//  HistoryView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/06/11.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit
import LineGraphView



final class HistoryView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private let screenWidth = UIScreen.main.bounds.width
    private var historyModel: [HistoryModel]!
    private var trueCounts:[Int]!
    
    
    private lazy var totalsTable: UITableView = {
        let tableView:UITableView = UITableView()
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "historyCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    
    private lazy var lineGraphView:LineGraphView = {
        let view:LineGraphView = LineGraphView(graphHeight: 290, values: trueCounts)
        view.strokeWidth = 3
        view.strokeColor = Rubyred
        view.duration = 1
        view.isAnime = true
        view.labelBackgroundColor = .white
        view.isHideLabel = false
        view.backgroundColor = .white
        view.ruledLine(lineWidth: screenWidth * 0.9)
        
        return view
    }()
    

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Beige

    }
    
    convenience init(frame: CGRect, historyModel model: [HistoryModel]) {
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
    
    
    
    private func viewLoad(){
        addSubview(lineGraphView)
        addSubview(totalsTable)
        
        setConstraint()
    }
    
    
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
    
    func lineAnimetion(){
        lineGraphView.setLineGraph()
    }
    
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












fileprivate final class HistoryCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(listValue: ListValue){
        textLabel?.text = listValue.title
        detailTextLabel?.text = listValue.value + "問"
    }
}
