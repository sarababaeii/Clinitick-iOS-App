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

enum State: String {
    case todo = "unknown"
    case done = "done"
    case canceled = "canceled"
}

@objc(Appointment)
public class Appointment: NSManagedObject {
    
    @available(iOS 13.0, *)
    static func createAppointment(name: String, phone: String, diseaseTitle: String, price: Int, alergies: String?, visit_time: Date, notes: String?) -> Appointment {
        
        let patient = Patient.getPatient(phone: phone, name: name, alergies: alergies)
        let disease = Disease.getDisease(title: diseaseTitle, price: price)
        return Info.dataController.createAppointment(patient: patient, disease: disease, price: price, visit_time: visit_time, notes: notes)
    }
    
    func setState(tag: Int) {
        if tag == 1 {
            self.state = State.done.rawValue
        } else if tag == 0 {
            self.state = State.canceled.rawValue
        }
//        if self.visit_time > Date() {
//            self.state = State.todo.rawValue
//        } else {
//            self.state = State.done.rawValue
//        }
    } //yes?
    
    func setID() {
        let uuid = UUID()
        self.id = uuid
    }
    
    func setPatient(patient: Patient) {
        self.patient = patient
        patient.addToHistory(self)
    }
    
    func setDisease(disease: Disease) {
        self.disease = disease
        disease.addToAppointments(self)
    }
    
    func setModifiedTime() {
        self.modifiedAt = Date()
    }
}
