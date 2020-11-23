//
//  TasksTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 10/23/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class TasksTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
   
    var tasksTableView: UITableView
    var date: Date = Date() {
        didSet {
            if let tasks = Info.dataController.fetchAppointmentsInDay(in: date) as? [Appointment] {
                update(newTasks: tasks)
            }
        }
    }
    
    var tasks = [Appointment]()
    
    //MARK: Initializer
    init(tasksTableView: UITableView, date: Date) {
        self.tasksTableView = tasksTableView
        self.date = date
        if let tasks = Info.dataController.fetchAppointmentsInDay(in: date) as? [Appointment] {
            self.tasks = tasks
        }
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellID", for: indexPath) as! TaskTableViewCell
        if let appointment = taskDataSource(indexPath: indexPath) {
            cell.setAttributes(appointment: appointment)
        }
        return cell
    }
    
    func taskDataSource(indexPath: IndexPath) -> Appointment? {
        if indexPath.row < tasks.count {
            return tasks[indexPath.row]
        }
        return nil
    }
    
    //MARK: Update
    func update(newTasks: [Appointment]) {
        for i in stride(from: tasks.count - 1, to: -1, by: -1) {
            deleteTask(index: i)
        }
        for task in newTasks {
            let indexPath = IndexPath(item: tasks.count, section: 0)
            insertTask(task, at: indexPath)
        }
    }
    
    func insertTask(_ appointment: Appointment?, at indexPath: IndexPath?) {
        if let appointment = appointment, let indexPath = indexPath {
            tasksTableView.performBatchUpdates({
                tasks.insert(appointment, at: indexPath.item)
                tasksTableView.insertRows(at: [indexPath], with: .automatic)
            }, completion: nil)
        }
    }
    
    func deleteTask(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tasksTableView.performBatchUpdates({
            if index < tasks.count {
                tasks.remove(at: index)
            }
            tasksTableView.deleteRows(at: [indexPath], with: .automatic)
            }, completion: nil)
    }
}
