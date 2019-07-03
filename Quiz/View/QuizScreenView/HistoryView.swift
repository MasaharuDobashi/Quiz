//
//  HistoryView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/06/11.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

fileprivate let screenWidth = UIScreen.main.bounds.width

final class HistoryView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var historyModel: [HistoryModel]!
    private var trueCounts:[CGFloat]!
    
    
    private lazy var lineGraphViewScrollView:UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.layer.borderWidth = 1
        scrollView.contentSize = CGSize(width: 20 * trueCounts.count, height: 300)
        return scrollView
    }()
    
    
    private lazy var totalsTable: UITableView = {
        let tableView:UITableView = UITableView()
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "historyCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    
    private lazy var lineView:LineView = {
        let view:LineView = LineView()
        view.getCounts(trueCount: trueCounts)
        
        return view
    }()
    

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white

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
        lineGraphViewScrollView.addSubview(lineView)
        addSubview(totalsTable)
        
        setConstraint()
    }
    
    
    private func setConstraint(){
        lineGraphViewScrollView.translatesAutoresizingMaskIntoConstraints = false
        lineGraphViewScrollView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        lineGraphViewScrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lineGraphViewScrollView.widthAnchor.constraint(equalToConstant: screenWidth * 0.9).isActive = true
        lineGraphViewScrollView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.topAnchor.constraint(equalTo: lineGraphViewScrollView.topAnchor, constant: 0).isActive = true
        lineView.leadingAnchor.constraint(equalTo: lineGraphViewScrollView.leadingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        totalsTable.translatesAutoresizingMaskIntoConstraints = false
        totalsTable.topAnchor.constraint(equalTo: lineGraphViewScrollView.bottomAnchor, constant: 10).isActive = true
        totalsTable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        totalsTable.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        totalsTable.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func lineAnimetion(){
        lineView.lineAnimetion()
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












fileprivate final class LineView: UIView {
    
    let lineLayer:CAShapeLayer = CAShapeLayer()
    var totals: [CGFloat]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCounts(trueCount: [CGFloat]){
        totals = trueCount
    }
    
    func lineAnimetion(){
        let viewHeight: CGFloat = 290
        
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 10, y: viewHeight - totals[0] * 25))
        for i in 1..<totals.count {
            path.addLine(to: CGPoint(x: 20 * CGFloat(i), y: viewHeight - totals[i] * 25))
        }
        
        
        layer.addSublayer(lineLayer)
        lineLayer.path = path.cgPath
        lineLayer.lineWidth = 3
        lineLayer.fillColor = UIColor.white.cgColor
        lineLayer.strokeColor = UIColor.red.cgColor
        
        let anime = CABasicAnimation(keyPath:"strokeEnd")
        anime.fromValue = 0.0
        anime.toValue = 1.0
        anime.timingFunction = CAMediaTimingFunction(name: .linear)
        anime.duration = 1
        anime.fillMode = .forwards
        
        lineLayer.add(anime, forKey: nil)
    }
}
