//
//  ClinicsTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ClinicsTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
   
    var tableView: UITableView
    var clinics = [Clinic]()
    
    //MARK: Initializer
    init(tableView: UITableView) {
        if let clinics = DataController.sharedInstance.fetchAllClinics() as? [Clinic] {
            self.clinics = clinics
            print(clinics.count)
            print("clinics: \(clinics)")
        }
        self.tableView = tableView
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clinics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClinicCellID", for: indexPath) as! ClinicTableViewCell
        if let clinic = clinicDataSource(indexPath: indexPath) {
            cell.setAttributes(clinic: clinic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction]?
        if let _ = clinicDataSource(indexPath: indexPath) {
            let delete = UITableViewRowAction(style: .destructive, title: "حذف") {
                (actions, indexPath) in
                self.deleteClinic(at: indexPath)
            }
            actions = [delete]
        }
        return actions
    }
    
    func clinicDataSource(indexPath: IndexPath) -> Clinic? {
        if indexPath.row < clinics.count {
            return clinics[indexPath.row]
        }
        return nil
    }
    
    func deleteClinic(at indexPath: IndexPath?) {
        if let indexPath = indexPath, let clinic = clinicDataSource(indexPath: indexPath) {
            tableView.beginUpdates()
            clinic.delete()
            clinics.remove(at: indexPath.row)
//            lastDeletedIndexPath = indexPath

//            if indexPath.section == 1 {
//                lastDeletedTask = priorityTasks[indexPath.row]
//                priorityTasks.remove(at: indexPath.row)
//            }
//            else{
//                lastDeletedTask = bonusTasks[indexPath.row]
//                bonusTasks.remove(at: indexPath.row)
//            }

            tableView.deleteRows(at: [indexPath], with: .automatic)

            tableView.endUpdates()
        }
    }
}
