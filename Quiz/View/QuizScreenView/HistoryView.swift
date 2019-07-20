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
    private var trueCounts:[CGFloat]!
    
    
    private lazy var lineGraphViewScrollView:UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.layer.borderWidth = 1
        scrollView.contentSize = CGSize(width: 22 * trueCounts.count, height: 300)
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    
    private lazy var totalsTable: UITableView = {
        let tableView:UITableView = UITableView()
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "historyCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    
    private lazy var lineGraphView:LineGraphView = {
        let view:LineGraphView = LineGraphView(graphHeight: 290, count: trueCounts)
        view.lineWidth = 3
        view.strokeColor = .red
        view.duration = 1
        view.isAnime = true
        view.labelBackgroundColor = .white
        view.isHideLabel = false
        view.backgroundColor = .white
        
        return view
    }()
    

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Beige

    }
    
    convenience init(frame: CGRect, historyModel model: [HistoryModel]) {
        self.init(frame: frame)
        historyModel = model
        trueCounts = [CGFloat]()
        
        for i in 0..<historyModel.count {
            let count:Int = Int(historyModel[i].quizTrueCount)!
            trueCounts.append(CGFloat(count))
        }
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func viewLoad(){
        addSubview(lineGraphViewScrollView)
        lineGraphViewScrollView.addSubview(lineGraphView)
        addSubview(totalsTable)
        
        setConstraint()
    }
    
    
    private func setConstraint(){
        lineGraphViewScrollView.translatesAutoresizingMaskIntoConstraints = false
        lineGraphViewScrollView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        lineGraphViewScrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lineGraphViewScrollView.widthAnchor.constraint(equalToConstant: screenWidth * 0.9).isActive = true
        lineGraphViewScrollView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        lineGraphView.translatesAutoresizingMaskIntoConstraints = false
        lineGraphView.topAnchor.constraint(equalTo: lineGraphViewScrollView.topAnchor, constant: 0).isActive = true
        lineGraphView.leadingAnchor.constraint(equalTo: lineGraphViewScrollView.leadingAnchor).isActive = true
        lineGraphView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        totalsTable.translatesAutoresizingMaskIntoConstraints = false
        totalsTable.topAnchor.constraint(equalTo: lineGraphViewScrollView.bottomAnchor, constant: 10).isActive = true
        totalsTable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        totalsTable.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        totalsTable.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func lineAnimetion(){
        lineGraphView.lineAnimetion()
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
