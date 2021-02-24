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
    
    var appointment: Appointment?
    
    func setAttributes(appointment: Appointment) {
        self.appointment = appointment
        diseaseTitleLabel.text = appointment.disease
        print(appointment.visit_time)
        print(Date.defaultDate())
        if appointment.visit_time != Date.defaultDate() {
            visitTimeLabel.text = appointment.visit_time.toPersianDMonthYString()
        }
        setState(state: appointment.state)
    }
    
    func setState(state: String) {
        if (state == TaskState.done.rawValue) {
            doneButton.selectCheckButton()
        } else if (state == TaskState.canceled.rawValue) {
            canceledButton.selectCheckButton()
        }
    }
    
    @IBAction func changeAppointmentState(_ sender: Any) {
        if let button = sender as? CheckButton, let appointment = appointment {
            appointment.updateState(state: button.discreption)
            button.visibleSelection()
        }
    }
}
