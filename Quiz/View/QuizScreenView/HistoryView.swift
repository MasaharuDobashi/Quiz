//
//  HistoryView.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/06/11.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

final class HistoryView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var view:UIView!
    private var table: UITableView!
    private var boderView:LineView!
    private var historyModel: [HistoryModel]!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        
        
       
    }
    
    convenience init(frame: CGRect, historyModel model: [HistoryModel]) {
        self.init(frame: frame)
        historyModel = model
        
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func viewLoad(){
        view = UIView()
        addSubview(view)
        
        boderView = LineView()
        view.addSubview(boderView)
        
        
        table = UITableView()
        table.register(HistoryCell.self, forCellReuseIdentifier: "historyCell")
        table.delegate = self
        table.dataSource = self
        addSubview(table)
        
        setConstraint()
        
    }
    
    
    private func setConstraint(){
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
        
        
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        table.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        table.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func lineAnimetion(){
        let screenWidth = UIScreen.main.bounds.width
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 90))
        path.addLine(to: CGPoint(x: screenWidth * 0.1, y: 280))
        path.addLine(to: CGPoint(x: screenWidth * 0.3, y: 20))
        path.addLine(to: CGPoint(x: screenWidth * 0.5, y: 130))
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.width - 10, y: 100))
        
        
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
