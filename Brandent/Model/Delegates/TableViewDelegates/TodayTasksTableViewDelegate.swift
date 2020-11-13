//
//  TodayTasksTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 11/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class TodayTasksTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    var tasks = [TodayTasks]()
    
    //MARK: Initializer
    override init() {
        if let tasks = Info.dataController.getTodayTasks() {
            self.tasks = tasks
        }
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTasksCellID", for: indexPath) as! TodayTasksTableViewCell
        if let task = todayTasksDataSource(indexPath: indexPath) {
            cell.setAttributes(tasks: task)
        }
        return cell
    }
    
    func todayTasksDataSource(indexPath: IndexPath) -> TodayTasks? {
        if indexPath.row < tasks.count {
            return tasks[tasks.count - indexPath.row - 1]
        }
        return nil
    }
}
