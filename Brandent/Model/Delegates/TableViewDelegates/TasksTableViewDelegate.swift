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
    var date: Date {
        didSet {
            if let tasks = DataController.sharedInstance.fetchTasksAndAppointments(in: date) as? [Entity] {
                update(newTasks: tasks)
                noTaskView.isHidden = tasks.count > 0
            }
        }
    }
    
    //MARK: Initializer
    init(viewController: UIViewController, tasksTableView: UITableView, date: Date, noTaskView: UIView) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellID", for: indexPath) as! TaskTableViewCell
        if let item = taskDataSource(indexPath: indexPath) {
            cell.setAttributes(item: item)
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
        for i in stride(from: items.count - 1, to: -1, by: -1) {
            removeTasks(index: i)
        }
        for task in newTasks {
            let indexPath = IndexPath(item: items.count, section: 0)
            insertTask(task, at: indexPath)
        }
    }
    
    func insertTask(_ item: Entity?, at indexPath: IndexPath?) {
        if let task = item, let indexPath = indexPath {
            tableView.performBatchUpdates({
                items.insert(task, at: indexPath.item)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }, completion: nil)
        }
    }
    
    func removeTasks(index: Int) { //remove all?!
        let indexPath = IndexPath(row: index, section: 0)
        tableView.performBatchUpdates({
            if index < items.count {
                items.remove(at: index)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }, completion: nil)
    }
    
    func deleteTask(at indexPath: IndexPath?) {
        if let indexPath = indexPath, let task = taskDataSource(indexPath: indexPath) {
            super.deleteItem(at: indexPath, item: task)
        }
    }
}
