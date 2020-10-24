//
//  TasksViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class TasksViewController: UIViewController {

    @IBOutlet weak var tasksTableView: UITableView!
    var taskTableViewDelegate: TasksTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Info.sharedInstance.lastViewController = self
        taskTableViewDelegate = TasksTableViewDelegate(tasksTableView: tasksTableView, date: Date())
        tasksTableView.delegate = taskTableViewDelegate
        tasksTableView.dataSource = taskTableViewDelegate
    }
}
