//
//  NearTasksTableViewCell.swift
//  Brandent
//
//  Created by Sara Babaei on 11/3/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class TodayTasksTableViewCell: UITableViewCell {
   
    @IBOutlet weak var colorView: CustomUIView!
    @IBOutlet weak var visitsNumberLabel: UILabel!
    @IBOutlet weak var clinicLabel: UILabel!
    
    func setAttributes(tasks: TodayTasks) {
        visitsNumberLabel.text = String(tasks.number).convertEnglishNumToPersianNum()
        setClinic(clinic: tasks.clinic)
    }
    
    func setClinic(clinic: Clinic?) {
        if let clinic = clinic {
            clinicLabel.text = "(\(clinic.title))"
            colorView.backgroundColor = Color.getColor(description: clinic.color).clinicColor
//                UIColor(hexString: clinic.color)
            clinicLabel.isHidden = false
        } else {
            clinicLabel.isHidden = true
        }
    }
}
