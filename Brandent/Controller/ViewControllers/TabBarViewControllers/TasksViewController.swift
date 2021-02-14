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
    @IBOutlet weak var tasksTableView: UITableView!
    
    var taskTableViewDelegate: TasksTableViewDelegate?
    
    //MARK: Initialization
    override func viewDidAppear(_ animated: Bool) {
        configure()
    }
    
    override func viewWillLayoutSubviews() {
        setDelegates()
    }
    
    func configure() {
        setUIComponent()
//        setDelegates()
        calendar.dateSelectHandler = { [unowned self] date in
            self.taskTableViewDelegate?.date = date
        }
    }
    
    func setUIComponent() {
        self.setGradientSizes() //for line
    }
    
    func setDelegates() {
        taskTableViewDelegate = TasksTableViewDelegate(tasksTableView: tasksTableView, date: Date())
        tasksTableView.delegate = taskTableViewDelegate
        tasksTableView.dataSource = taskTableViewDelegate
    }
    
    @IBAction func selectToday(_ sender: Any) {
        calendar.selectToday()
    }
}
