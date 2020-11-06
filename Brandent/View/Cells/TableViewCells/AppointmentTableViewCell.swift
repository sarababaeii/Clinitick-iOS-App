//
//  AppointmentTableViewCell.swift
//  Brandent
//
//  Created by Sara Babaei on 11/3/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AppointmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var diseaseTitleLabel: UILabel!
    @IBOutlet weak var visitTimeLabel: UILabel!
    @IBOutlet weak var doneButton: CheckButton!
    @IBOutlet weak var canceledButton: CheckButton!
    
    func setAttributes(appointment: Appointment) {
        diseaseTitleLabel.text = appointment.disease.title
        visitTimeLabel.text = appointment.visit_time.toPersianDMonthYString()
        setState(state: appointment.state)
    }
    
    func setState(state: String) {
        if (state == State.done.rawValue) {
            doneButton.selectCheckButton()
        } else if (state == State.canceled.rawValue) {
            canceledButton.selectCheckButton()
        }
    }
}
