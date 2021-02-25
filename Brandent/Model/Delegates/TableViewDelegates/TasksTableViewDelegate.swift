//
//  TasksTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 10/23/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class TasksTableViewDelegate: DeletableTableViewDelegate, UITableViewDelegate, UITableViewDataSource {
   
    var noTaskView: UIView
    var hasDateChanged = false
    var date: Date {
        willSet {
            if newValue != date {
                hasDateChanged = true
            }
        }
        didSet {
            if hasDateChanged, let tasks = DataController.sharedInstance.fetchTasksAndAppointments(in: date) as? [Entity] {
                print("!!!")
                print(tasks)
                print("!!!")
                hasDateChanged = false
                update(newTasks: tasks)
                noTaskView.isHidden = tasks.count > 0
            }
        }
    }
    
    //MARK: Initializer
    init(viewController: UIViewController, tasksTableView: UITableView, noTaskView: UIView, date: Date) {
        self.noTaskView = noTaskView
        self.date = date
        let tasks = DataController.sharedInstance.fetchTasksAndAppointments(in: date) as? [Entity]
        noTaskView.isHidden = tasks?.count ?? 1 > 0
        super.init(viewController: viewController, tableView: tasksTableView, items: tasks)
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entiti = taskDataSource(indexPath: indexPath)
        var cell = TaskTableViewCell()
        if let task = entiti as? Task {
            cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellID", for: indexPath) as! TaskTableViewCell
            cell.setAttributes(item: task)
        }
        if let appointment = entiti as? Appointment {
            cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentInTaskCellID", for: indexPath) as! TaskTableViewCell
            cell.setAttributes(item: appointment)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction]?
        if let _ = taskDataSource(indexPath: indexPath) {
            let delete = UITableViewRowAction(style: .destructive, title: "حذف") {
                (actions, indexPath) in
                self.deleteTask(at: indexPath)
            }
//            delete.accessibilityAttributedLabel
            actions = [delete]
        }
        return actions
    }
    
    func taskDataSource(indexPath: IndexPath) -> Entity? {
        if indexPath.row < items.count {
            return items[indexPath.row]
        }
        return nil
    }
    
    //MARK: Update
    func update(newTasks: [Entity]) {
        items.removeAll()
        items = newTasks
        tableView.reloadData()
    }
    
    override func insertItemInTableView() {
        if let appointment = deletedItem as? Appointment, appointment.visit_time.isInSameDay(date: date) {
            super.insertItemInTableView()
        }
        else if let task = deletedItem as? Task, task.date.isInSameDay(date: date) {
            super.insertItemInTableView()
        }
    }
    
    func deleteTask(at indexPath: IndexPath?) {
        if let indexPath = indexPath, let task = taskDataSource(indexPath: indexPath) {
            super.deleteItem(at: indexPath, item: task)
        }
    }
}

//TODO: deleted item, then changed selected date and then came back to first date -> don't show deleted item
