//
//  ClinicsTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class ClinicsTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
   
    var clinics = [Clinic]()
    
    //MARK: Initializer
    override init() {
        if let clinics = Info.dataController.fetchAllClinics() as? [Clinic] {
            self.clinics = clinics
        }
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
    
    func clinicDataSource(indexPath: IndexPath) -> Clinic? {
        if indexPath.row < clinics.count {
            return clinics[indexPath.row]
        }
        return nil
    }
}
