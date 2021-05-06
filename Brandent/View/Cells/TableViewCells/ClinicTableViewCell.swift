//
//  ClinicTableViewCell.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ClinicTableViewCell: UITableViewCell {
    @IBOutlet weak var colorView: CustomUIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var clinic: Clinic?
    
    func setAttributes(clinic: Clinic) {
        self.clinic = clinic
        titleLabel.text = clinic.title
        colorView.backgroundColor = Color.getColor(description: clinic.color).clinicColor
//            UIColor(hexString: clinic.color)
    }
}
