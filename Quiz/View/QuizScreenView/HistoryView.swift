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
    
    private var lineGraphView:UIView!
    private var totalsTable: UITableView!
    private var boderView:LineView!
    private var historyModel: [HistoryModel]!
    private var trueCounts:[CGFloat]!
    
    
    
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
        lineGraphView = UIView()
        addSubview(lineGraphView)
        
        boderView = LineView()
//        lineGraphView.layer.borderWidth = 1
        
        boderView.getCounts(trueCount: trueCounts)
        lineGraphView.addSubview(boderView)
        
        
        totalsTable = UITableView()
        totalsTable.register(HistoryCell.self, forCellReuseIdentifier: "historyCell")
        totalsTable.delegate = self
        totalsTable.dataSource = self
        addSubview(totalsTable)
        
        setConstraint()
        
    }
    
    
    private func setConstraint(){
        lineGraphView.translatesAutoresizingMaskIntoConstraints = false
        lineGraphView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        lineGraphView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lineGraphView.widthAnchor.constraint(equalToConstant: screenWidth * 0.9).isActive = true
        lineGraphView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        boderView.translatesAutoresizingMaskIntoConstraints = false
        boderView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        boderView.leadingAnchor.constraint(equalTo: lineGraphView.leadingAnchor).isActive = true
        boderView.trailingAnchor.constraint(equalTo: lineGraphView.trailingAnchor).isActive = true
        boderView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        totalsTable.translatesAutoresizingMaskIntoConstraints = false
        totalsTable.topAnchor.constraint(equalTo: lineGraphView.bottomAnchor, constant: 0).isActive = true
        totalsTable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        totalsTable.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        totalsTable.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func lineAnimetion(){
        boderView.lineAnimetion()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let historyCell: HistoryCell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryCell
        
        historyCell.setValue(date: historyModel[indexPath.row].date, count: historyModel[indexPath.row].quizTrueCount)
        
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
    
    func setValue(date: String, count: String){
        textLabel?.text = date
        
        detailTextLabel?.text = count + "問"
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
        
        path.move(to: CGPoint(x: 10, y: viewHeight - totals[0] * 40))
        for i in 1..<totals.count {
            path.addLine(to: CGPoint(x: screenWidth * (CGFloat(i) * 0.05), y: viewHeight - totals[i] * 40))
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
