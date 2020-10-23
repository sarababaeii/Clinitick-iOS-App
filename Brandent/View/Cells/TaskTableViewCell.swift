//
//  TaskTableViewCell.swift
//  Brandent
//
//  Created by Sara Babaei on 10/23/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var diseaseLabel: UILabel!
    @IBOutlet weak var visitTimeLabel: UILabel!
    @IBOutlet weak var doneButton: CustomButton!
    @IBOutlet weak var canceledButton: CustomButton!
    
    func setAttributes(appointment: Appointment){
        patientNameLabel.text = appointment.patient.name
        diseaseLabel.text = appointment.disease?.title
//        visitTimeLabel.text
        if appointment.state == State.done.rawValue {
//            doneButton.select()
        } else if appointment.state == State.canceled.rawValue {
//            canceledButton.select()
        }
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
}
