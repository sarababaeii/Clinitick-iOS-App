//
//  TasksTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 10/23/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class TasksTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
   
    var tableView: UITableView
    var date: Date = Date() {
        didSet {
            if let tasks = DataController.sharedInstance.fetchTasksAndAppointments(in: date) as? [Entity] {
                update(newTasks: tasks)
            }
        }
    }
    
    var tasks = [Entity]()
    
    //MARK: Initializer
    init(tasksTableView: UITableView, date: Date) {
        self.tableView = tasksTableView
        self.date = date
        if let tasks = DataController.sharedInstance.fetchTasksAndAppointments(in: date) as? [Entity] {
            self.tasks = tasks
            print(tasks)
        }
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
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
        if indexPath.row < tasks.count {
            return tasks[indexPath.row]
        }
        return nil
    }
    
    //MARK: Update
    func update(newTasks: [Entity]) {
        for i in stride(from: tasks.count - 1, to: -1, by: -1) {
            removeTasks(index: i)
        }
        for task in newTasks {
            let indexPath = IndexPath(item: tasks.count, section: 0)
            insertTask(task, at: indexPath)
        }
    }
    
    func insertTask(_ item: Entity?, at indexPath: IndexPath?) {
        if let task = item, let indexPath = indexPath {
            tableView.performBatchUpdates({
                tasks.insert(task, at: indexPath.item)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }, completion: nil)
        }
    }
    
    func removeTasks(index: Int) { //remove all?!
        let indexPath = IndexPath(row: index, section: 0)
        tableView.performBatchUpdates({
            if index < tasks.count {
                tasks.remove(at: index)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }, completion: nil)
    }
    
    func deleteTask(at indexPath: IndexPath?) {
        if let indexPath = indexPath, let task = taskDataSource(indexPath: indexPath) {
            tableView.beginUpdates()
            task.delete()
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
