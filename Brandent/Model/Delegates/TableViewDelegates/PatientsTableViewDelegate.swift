//
//  PatientsTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class PatientsTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
   
    var tableView: UITableView
    var patients = [Patient]()
    
    //MARK: Initializer
    init(tableView: UITableView) {
        if let patients = DataController.sharedInstance.fetchAllPatients() as? [Patient] {
            self.patients = patients
        }
        self.tableView = tableView
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
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
        if indexPath.row < patients.count {
            return patients[indexPath.row]
        }
        return nil
    }
    
    func deletePatient(at indexPath: IndexPath?) {
        if let indexPath = indexPath, let patient = patientDataSource(indexPath: indexPath) {
            tableView.beginUpdates()
//            patient.delete()
            patients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
