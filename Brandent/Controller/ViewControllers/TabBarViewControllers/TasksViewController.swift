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

    @IBOutlet weak var calendar: GDCalendar!
    @IBOutlet weak var line: LightningUIView!
    @IBOutlet weak var tasksTableView: UITableView!
    
    var taskTableViewDelegate: TasksTableViewDelegate?
    
    @IBAction func selectToday(_ sender: Any) {
        calendar.selectToday()
    }
    
    func setUIComponent() {
        self.setGradientSizes()
    }
    
    func configure() {
        setUIComponent()
        calendar.dateSelectHandler = { [unowned self] date in
            self.taskTableViewDelegate?.date = date
        }
    }
    
    func setDelegates() {
        taskTableViewDelegate = TasksTableViewDelegate(tasksTableView: tasksTableView, date: Date())
        tasksTableView.delegate = taskTableViewDelegate
        tasksTableView.dataSource = taskTableViewDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
    
    //MARK: Hiding NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        Info.sharedInstance.lastViewControllerIndex = TabBarItemIndex.tasks.rawValue
        setDelegates()
    }
}

//TODO: save changing state to DB
