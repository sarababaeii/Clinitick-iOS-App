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
   
    var patients = [Patient]()
    
    //MARK: Initializer
    override init() {
        if let patients = DataController.sharedInstance.fetchAllPatients() as? [Patient] {
            self.patients = patients
        }
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
    
    func patientDataSource(indexPath: IndexPath) -> Patient? {
        if indexPath.row < patients.count {
            return patients[indexPath.row]
        }
        return nil
    }
}
