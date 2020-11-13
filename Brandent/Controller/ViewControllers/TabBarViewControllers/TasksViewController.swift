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
    
    func setDelegates() {
        taskTableViewDelegate = TasksTableViewDelegate(tasksTableView: tasksTableView, date: Date())
        tasksTableView.delegate = taskTableViewDelegate
        tasksTableView.dataSource = taskTableViewDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Info.sharedInstance.lastViewController = self
        setDelegates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

//TODO: Calendar
