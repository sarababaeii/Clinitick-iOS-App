//
//  Appointment+CoreDataClass.swift
//  Brandent
//
//  Created by Sara Babaei on 9/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Appointment)
public class Appointment: NSManagedObject {
    
    @available(iOS 13.0, *)
    static func createAppointment(name: String, phone: String, diseaseTitle: String, price: Int, alergies: String?, visit_time: Date, notes: String?) -> Appointment {
        let patient = Patient.getPatient(phone: phone, name: name, alergies: alergies)
        let disease = Disease.getDisease(title: diseaseTitle, price: price)
        return Info.dataController.createAppointment(patient: patient, disease: disease, price: price, visit_time: visit_time, notes: notes)
    }
}
