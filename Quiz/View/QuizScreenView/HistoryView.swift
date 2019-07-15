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
    
    
    private lazy var lineGraphView:LineGraphView = {
        let view:LineGraphView = LineGraphView(graphHeight: 290, count: trueCounts)
        view.lineWidth = 3
        view.strokeColor = .red
        view.duration = 1
        view.isAnime = true
        view.labelBackgroundColor = .white
        view.isHideLabel = false
        
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












fileprivate final class LineGraphView: UIView {
    
    private let lineLayer:CAShapeLayer = CAShapeLayer()
    var valueCount: [CGFloat]?
    var isAnime: Bool = true
    
    var lineWidth: CGFloat = 1
    var strokeColor: UIColor = UIColor.black
    var fromValue: Any? = 0.0
    var toValue: Any? = 1.0
    var duration:  CFTimeInterval = 1
    var graphHeight: CGFloat = 0
    var timingFunction:CAMediaTimingFunction? = .init(name: .linear)
    
    var valueLabel:UILabel {
        let label: UILabel = UILabel()
        label.backgroundColor = labelBackgroundColor
        label.textColor = labelTextColor
        label.font = labelFont
        label.textAlignment = labelTextAlignment
        label.isHidden = isHideLabel
        
        return label
    }
    
    var labelBackgroundColor:UIColor = .clear
    var labelFont: UIFont?
    var labelTextColor: UIColor?
    var labelTextAlignment:NSTextAlignment = .right
    var isHideLabel:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    
    convenience init(graphHeight height: CGFloat, count: [CGFloat]){
        self.init()
        graphHeight = height
        valueCount = count
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func lineAnimetion(){
        guard let _valueCount = valueCount else {
            debugPrint("valueCount is nil")
            return
        }
        layer.addSublayer(lineLayer)
        let path = UIBezierPath()
        let graphY: CGFloat = (graphHeight / 12)
        let lableY: CGFloat = (graphHeight / 11)
        path.move(to: CGPoint(x: 20, y: graphHeight - _valueCount[0] * graphY))
        
        let firstLabel: UILabel = {
            let label:UILabel = valueLabel
            label.frame = CGRect(x: 20, y: graphHeight - _valueCount[0] * lableY - 10, width: 0, height: 0)
            label.text = "\(Int(_valueCount[0]))"
            label.textColor = .black
            label.sizeToFit()
            
            return label
        }()
        addSubview(firstLabel)
        
        for i in 1..<_valueCount.count {
            path.addLine(to: CGPoint(x: 20 * CGFloat(i), y: graphHeight - _valueCount[i] * graphY))
            
            let label: UILabel = {
                let label:UILabel = valueLabel
                label.frame = CGRect(x: 20 * CGFloat(i), y: graphHeight - _valueCount[i] * lableY - 10, width: 0, height: 0)
                label.text = "\(Int(_valueCount[i]))"
                label.sizeToFit()
                
                return label
            }()
            addSubview(label)
        }
        
        lineLayer.path = path.cgPath
        lineLayer.lineWidth = lineWidth
        lineLayer.fillColor = UIColor.white.cgColor
        lineLayer.strokeColor = strokeColor.cgColor
        
        if isAnime == true {
            let anime = CABasicAnimation(keyPath:"strokeEnd")
            anime.fromValue = fromValue
            anime.toValue = toValue
            anime.timingFunction = timingFunction
            anime.duration = duration
            anime.fillMode = .forwards
            
            
            lineLayer.add(anime, forKey: nil)
        }
    }
}
