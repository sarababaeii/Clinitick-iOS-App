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
    var date: Date = Date()
    //{
//        didSet {
//            if let tasks = Info.dataController.fetchAppointments(visitTime: date) as? [Appointment] {
//                self.tasks = tasks
//            }
//        }        
//}
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
        print("asked for cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellID", for: indexPath) as! TaskTableViewCell
        if let appointment = taskDataSource(indexPath: indexPath) {
            cell.setAttributes(appointment: appointment)
        }
        return cell
    }
    
    func taskDataSource(indexPath: IndexPath) -> Appointment? {
        if indexPath.row < tasks.count {
            return tasks[tasks.count - indexPath.row - 1]
        }
        return nil
    }
}

//TODO: sort by time
