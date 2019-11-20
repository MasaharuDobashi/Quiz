//
//  ManagementViewDelegate.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/11/06.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import Foundation
import UIKit

protocol ManagementViewDelegate: class {
    func editAction(_ tableViewController: UITableViewController, editViewController editVC: UIViewController)
    func deleteAction(indexPath: IndexPath)
    func detailAction(indexPath: IndexPath)
}










