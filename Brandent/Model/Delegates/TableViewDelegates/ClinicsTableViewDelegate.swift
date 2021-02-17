//
//  ClinicsTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ClinicsTableViewDelegate: DeletableTableViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Initializer
    init(viewController: UIViewController, tableView: UITableView) {
        let clinics = DataController.sharedInstance.fetchAllClinics() as? [Clinic]
        super.init(viewController: viewController, tableView: tableView, items: clinics)
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
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
        if indexPath.row < items.count {
            return items[indexPath.row] as? Clinic
        }
        return nil
    }
    
    func deleteClinic(at indexPath: IndexPath?) {
        if let indexPath = indexPath, let clinic = clinicDataSource(indexPath: indexPath) {
            super.deleteItem(at: indexPath, item: clinic)
        }
    }
}
