//
//  AppointmentsTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 11/3/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AppointmentsTableViewDelegate: DeletableTableViewDelegate, UITableViewDelegate, UITableViewDataSource {
   
    var patient: Patient
    
    //MARK: Initializer
    init(viewController: UIViewController, tableView: UITableView, patient: Patient) {
        self.patient = patient
        var appointments = [Appointment]()
        if let history = patient.history?.allObjects as? [Appointment] {
            appointments = Array(history)
        } //TODO: sort by visit time
        super.init(viewController: viewController, tableView: tableView, items: appointments)
        preprocessAppointments()
    }
    
    func preprocessAppointments() {
        var i = 0
        while i < items.count {
            print("\(i), \(items.count)")
            if items[i].is_deleted {
                items.remove(at: i)
                i -= 1
            }
            i += 1
        }
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCellID", for: indexPath) as! AppointmentTableViewCell
        if let appointment = appointmentDataSource(indexPath: indexPath) {
            cell.setAttributes(appointment: appointment)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction]?
        if let _ = appointmentDataSource(indexPath: indexPath) {
            let delete = UITableViewRowAction(style: .destructive, title: "حذف") {
                (actions, indexPath) in
                self.deleteAppointment(at: indexPath)
            }
            actions = [delete]
        }
        return actions
    }
    
    func appointmentDataSource(indexPath: IndexPath) -> Appointment? {
        if indexPath.row < items.count {
            return items[indexPath.row] as? Appointment
        }
        return nil
    }
    
    func deleteAppointment(at indexPath: IndexPath?) {
        if let indexPath = indexPath, let appointment = appointmentDataSource(indexPath: indexPath) {
            super.deleteItem(at: indexPath, item: appointment)
        }
    }
}
