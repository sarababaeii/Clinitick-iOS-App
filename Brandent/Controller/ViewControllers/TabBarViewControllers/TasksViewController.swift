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
        appearConfigure()
    }
    
    func loadConfigure() {
        calendar.dateSelectHandler = { [unowned self] date in
            self.taskTableViewDelegate?.date = date
        }
    }
    
    func appearConfigure() {
        setDelegates()
    }
    
    func setDelegates() {
        taskTableViewDelegate = TasksTableViewDelegate(viewController: self, tasksTableView: tasksTableView, noTaskView: noTaskView, date: taskTableViewDelegate?.date ?? Date().today)
        tasksTableView.delegate = taskTableViewDelegate
        tasksTableView.dataSource = taskTableViewDelegate
    }
    
    @IBAction func selectToday(_ sender: Any) {
        calendar.selectToday()
    }
    
    //MARK: Sending Data With Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? TaskTableViewCell, let entity = cell.entity else {
            return
        }
        if segue.identifier == "EditTaskSegue",
            let task = entity as? Task,
            let viewController = segue.destination as? AddTaskViewController {
                viewController.task = task
        }
        if segue.identifier == "EditAppointmentFromTasksSegue",
            let appointment = entity as? Appointment,
            let viewController = segue.destination as? TempAddAppointmrntViewController {
                viewController.appointment = appointment
        }
    }
}
