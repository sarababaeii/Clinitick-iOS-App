//
//  FinanceTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 11/6/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FinanceTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
   
    var tableView: UITableView
    var finances = [Entity]()
    
    //MARK: Initializer
    init(tableView: UITableView, finances: [Entity]) {
        self.finances = finances
        self.tableView = tableView
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceCellID", for: indexPath) as! FinanceTableViewCell
        if let finance = financeDataSource(indexPath: indexPath) {
            cell.setAttributes(item: finance)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction]?
        if let _ = financeDataSource(indexPath: indexPath) {
            let delete = UITableViewRowAction(style: .destructive, title: "حذف") {
                (actions, indexPath) in
                self.deleteFinance(at: indexPath)
            }
            actions = [delete]
        }
        return actions
    }
    
    func financeDataSource(indexPath: IndexPath) -> Entity? {
        if indexPath.row < finances.count {
            return finances[indexPath.row]
        }
        return nil
    }
    
    func deleteFinance(at indexPath: IndexPath?) {
        if let indexPath = indexPath, let finance = financeDataSource(indexPath: indexPath) {
            tableView.beginUpdates()
            finance.delete()
            finances.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
