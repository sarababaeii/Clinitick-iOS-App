//
//  AppointmentsTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 11/3/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AppointmentsTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
   
    var patient: Patient
    var appointments = [Appointment]()
    
    //MARK: Initializer
    init(patient: Patient) {
        self.patient = patient
        if let appointments = patient.history?.allObjects as? [Appointment] {
            self.appointments = Array(appointments)
        } //TODO: sort by visit time
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCellID", for: indexPath) as! AppointmentTableViewCell
        if let appointment = appointmentDataSource(indexPath: indexPath) {
            cell.setAttributes(appointment: appointment)
        }
        return cell
    }
    
    func appointmentDataSource(indexPath: IndexPath) -> Appointment? {
        if indexPath.row < appointments.count {
            return appointments[indexPath.row]
        }
        return nil
    }
}
