//
//  TasksViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class TasksViewController: TabBarViewController {

    @IBOutlet weak var calendar: GDCalendar!
    @IBOutlet weak var line: LightningUIView!
    @IBOutlet weak var noTaskView: UIView!
    @IBOutlet weak var tasksTableView: UITableView!
    
    var taskTableViewDelegate: TasksTableViewDelegate?
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConfigure()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutConfigure()
    }
    
    func loadConfigure() {
        calendar.dateSelectHandler = { [unowned self] date in
            self.taskTableViewDelegate?.date = date
        }
    }
    
    func layoutConfigure() {
        setDelegates()
    }
    
    func setDelegates() {
        taskTableViewDelegate = TasksTableViewDelegate(viewController: self, tasksTableView: tasksTableView, date: Date(), noTaskView: noTaskView)
        tasksTableView.delegate = taskTableViewDelegate
        tasksTableView.dataSource = taskTableViewDelegate
    }
    
    @IBAction func selectToday(_ sender: Any) {
        calendar.selectToday()
    }
}
