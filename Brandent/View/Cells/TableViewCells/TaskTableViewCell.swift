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
    @IBOutlet weak var diseaseLabel: UILabel! // just for appointment
    @IBOutlet weak var visitTimeLabel: UILabel!
    @IBOutlet weak var doneButton: CheckButton!
    @IBOutlet weak var canceledButton: CheckButton!
    
    var entity: Any?
    
    func setAttributes(item: Any) {
        self.entity = item
        if let appointment = item as? Appointment {
            setAppointmentAttributes(appointment: appointment)
        }
        else if let task = item as? Task {
            setTaskAttributes(task: task)
        }
    }
    
    func setAppointmentAttributes(appointment: Appointment) {
        patientNameLabel.text = appointment.patient.name
        diseaseLabel.text = appointment.disease
        visitTimeLabel.text = appointment.visit_time.toPersianTimeString()
        setState(appointment: appointment)
    }
    
    func setTaskAttributes(task: Task) {
        patientNameLabel.text = task.title
        diseaseLabel.text = ""
        visitTimeLabel.text = task.date.toPersianTimeString()
        setState(task: task)
    }
    
    func setState(appointment: Appointment) {
        if appointment.state == TaskState.done.rawValue {
            doneButton.visibleSelection()
        } else if appointment.state == TaskState.canceled.rawValue {
            canceledButton.visibleSelection()
        } else {
            showDefaultState()
        }
    }
    
    func setState(task: Task) {
        if task.state == TaskState.done.rawValue {
            doneButton.visibleSelection()
        } else if task.state == TaskState.canceled.rawValue {
            canceledButton.visibleSelection()
        } else {
            showDefaultState()
        }
    }
    
    func showDefaultState() {
        doneButton.unselectCheckButton()
        canceledButton.unselectCheckButton()
    }
    
    @IBAction func changeTaskState(_ sender: Any) {
        if let button = sender as? CheckButton {
            if let appointment = entity as? Appointment {
                if appointment.updateState(state: button.discreption) {
                    button.visibleSelection()
                } else {
                    button.unselectCheckButton()
                }
            } else if let task = entity as? Task {
                if task.updateState(state: button.discreption) {
                    button.visibleSelection()
                }else {
                    button.unselectCheckButton()
                }
            }
        }
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
}
