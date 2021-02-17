//
//  FinanceTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 11/6/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class FinanceTableViewDelegate: DeletableTableViewDelegate, UITableViewDelegate, UITableViewDataSource {
      
    //MARK: Initializer
    init(viewController: UIViewController, tableView: UITableView, finances: [Entity]) {
        super.init(viewController: viewController, tableView: tableView, items: finances)
        print(items)
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
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
        if indexPath.row < items.count {
            return items[indexPath.row]
        }
        return nil
    }
    
    func deleteFinance(at indexPath: IndexPath?) {
        if let indexPath = indexPath, let finance = financeDataSource(indexPath: indexPath) {
            super.deleteItem(at: indexPath, item: finance)
        }
    }
}
