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
    
    func setAttributes(patient: Patient) {
        nameLabel.text = patient.name
        phoneLabel.text = patient.phone
    }
}
