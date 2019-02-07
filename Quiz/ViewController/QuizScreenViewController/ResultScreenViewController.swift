//
//  ResultScreenViewController.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/24.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

class ResultScreenViewController: UIViewController,ResultScreenViewDelegate {
    var trueConunt: Int = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(trueConunt:Int){
        self.init(nibName: nil, bundle: nil)
        self.trueConunt = trueConunt
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftButtonAction))
        
        let resultScreenView:ResultScreenView = ResultScreenView(frame: frame_Size(viewController: self), trueConunt:trueConunt)
        self.view.addSubview(resultScreenView)
    }
    
}
