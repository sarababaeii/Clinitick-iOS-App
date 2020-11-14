//
//  PatientTableViewCell.swift
//  Brandent
//
//  Created by Sara Babaei on 10/28/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class PatientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var patient: Patient?
    
    func setAttributes(patient: Patient) {
        self.patient = patient
        nameLabel.text = patient.name
        phoneLabel.text = patient.phone
    }
}
