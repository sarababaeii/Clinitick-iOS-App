//
//  TasksViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class TasksViewController: UIViewController {

    @IBOutlet weak var tasksTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Info.sharedInstance.lastViewController = self
    }
}
