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
      
    var tag: Int
    var hasDateChanged = false
    var date: Date {
        willSet {
            if newValue != date {
                hasDateChanged = true
            }
        }
        didSet {
            if hasDateChanged, let finances = Finance.getFinancesArray(tag: tag, date: date) {
                hasDateChanged = false
                update(newFinances: finances)
            }
        }
    }
    var sum: Int = 0 {
        didSet {
            if let viewController = viewController as? SeeFinanceViewController {
                viewController.setTotalAmount(totalAmount: sum)
            }
        }
    }
    
    //MARK: Initializer
    init(viewController: SeeFinanceViewController, tableView: UITableView, tag: Int) {
        self.tag = tag
        self.date = Date()
        let finances = Finance.getFinancesArray(tag: tag, date: date)
        super.init(viewController: viewController, tableView: tableView, items: finances)
        sum = Finance.calculateSum(finances: finances)
        viewController.setTotalAmount(totalAmount: sum)
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entiti = financeDataSource(indexPath: indexPath)
        var cell = FinanceTableViewCell()
        if let finance = entiti as? Finance {
            cell = tableView.dequeueReusableCell(withIdentifier: "FinanceCellID", for: indexPath) as! FinanceTableViewCell
            cell.setAttributes(item: finance)
        }
        if let appointment = entiti as? Appointment {
            cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentInFinanceCellID", for: indexPath) as! FinanceTableViewCell
            cell.setAttributes(item: appointment)
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
    
    func update(newFinances: [Entity]) {
        items.removeAll()
        items = newFinances
        tableView.reloadData()
        sum = Finance.calculateSum(finances: newFinances)
    }
    
    override func deleteItemInTableView() {
        super.deleteItemInTableView()
        if let appointment = deletedItem as? Appointment {
            sum -= Int(truncating: appointment.price)
        }
        else if let finance = deletedItem as? Finance {
            sum -= finance.getAmount()
        }
    }
    
    override func insertItemInTableView() {
        if let appointment = deletedItem as? Appointment, appointment.visit_time.isInSameMonth(date: date) {
            sum += Int(truncating: appointment.price)
            super.insertItemInTableView()
        }
        else if let finance = deletedItem as? Finance, finance.date.isInSameMonth(date: date) {
            super.insertItemInTableView()
            sum += finance.getAmount()
        }
    }
    
    func deleteFinance(at indexPath: IndexPath?) {
        if let indexPath = indexPath, let finance = financeDataSource(indexPath: indexPath) {
            super.deleteItem(at: indexPath, item: finance)
        }
    }
}
