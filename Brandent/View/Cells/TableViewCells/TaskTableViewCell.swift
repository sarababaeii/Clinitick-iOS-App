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
    @IBOutlet weak var doneButton: CheckButton!
    @IBOutlet weak var canceledButton: CheckButton!
    
    var item: Any?
    
    func setAttributes(item: Any) {
        self.item = item
        if let appointment = item as? Appointment {
            setAppointmentAttributes(appointment: appointment)
        }
        else if let task = item as? Task {
            setTaskAttributes(task: task)
        }
    }
    
    func setAppointmentAttributes(appointment: Appointment) {
        patientNameLabel.text = appointment.patient.name
        diseaseLabel.text = appointment.disease.title
        visitTimeLabel.text = appointment.visit_time.toPersianTimeString()
        setState(appointment: appointment)
    }
    
    func setTaskAttributes(task: Task) {
        patientNameLabel.text = task.title
        visitTimeLabel.text = task.date.toPersianTimeString()
//        setState(appointment: task)
    }
    
    func setState(appointment: Appointment) {
        if appointment.state == State.done.rawValue {
            changeAppointmentState(doneButton as Any)
        } else if appointment.state == State.canceled.rawValue {
            changeAppointmentState(canceledButton as Any)
        }
    }
    
    @IBAction func changeAppointmentState(_ sender: Any) {
        if let button = sender as? CheckButton {
//            item?.setState(tag: button.tag)
            button.visibleSelection()
        }
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
}
