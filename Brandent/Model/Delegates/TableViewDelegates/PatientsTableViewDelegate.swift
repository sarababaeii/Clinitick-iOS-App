//
//  PatientsTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class PatientsTableViewDelegate: DeletableTableViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Initializer
    init(viewController: UIViewController, tableView: UITableView) {
        let patients = Info.sharedInstance.dataController?.fetchAllPatients() as? [Patient]
        super.init(viewController: viewController, tableView: tableView, items: patients)
    }
    
    func updateItems() {
        items = Info.sharedInstance.dataController?.fetchAllPatients() as? [Patient] ?? [Patient]()
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCellID", for: indexPath) as! PatientTableViewCell
        if let patient = patientDataSource(indexPath: indexPath) {
            cell.setAttributes(patient: patient)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction]?
        if let _ = patientDataSource(indexPath: indexPath) {
            let delete = UITableViewRowAction(style: .destructive, title: "حذف") {
                (actions, indexPath) in
                self.deletePatient(at: indexPath)
            }
            actions = [delete]
        }
        return actions
    }
    
    func patientDataSource(indexPath: IndexPath) -> Patient? {
        if indexPath.row < items.count {
            return items[indexPath.row] as? Patient
        }
        return nil
    }
    
    func deletePatient(at indexPath: IndexPath?) {
        if let indexPath = indexPath, let patient = patientDataSource(indexPath: indexPath) {
            super.deleteItem(at: indexPath, item: patient)
        }
    }
}
