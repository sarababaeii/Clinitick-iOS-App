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
        return Info.dataController.createAppointment(patient: patient, disease: disease, price: price, visit_time: visit_time, alergies: alergies, notes: notes)
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
        self.modified_at = Date()
    }
    
    func toDictionary() -> [String: String] {
        var params = [
            APIKey.appointment.id!: self.id.uuidString,
            APIKey.appointment.price!: String(Int(truncating: self.price)),
            APIKey.appointment.state!: self.state,
            APIKey.appointment.date!: self.visit_time.toDBFormatDateAndTimeString(),
            APIKey.appointment.disease!: self.disease.title,
            APIKey.appointment.isDeleted!: String(self.isDeleted), //test
//            APIKey.appointment.clinic!: (self.clinic?.id.uuidString)!, //test
            APIKey.appointment.clinic!: "890a32fe-12e6-11eb-adc1-0242ac120002", //should be changed
            APIKey.appointment.patient!: self.patient.id.uuidString,
            APIKey.patient.name!: self.patient.name, //should be deleted
            APIKey.patient.phone!: self.patient.phone //should be deleted
        ]
        if let notes = self.notes {
            params[APIKey.appointment.notes!] = notes
        }
        if let alergies = self.alergies {
            params[APIKey.appointment.alergies!] = alergies
        }
        return params
    }
    
    static func toDictionaryArray(appointments: [Appointment]) -> [[String: String]] {
        var params = [[String: String]]()
        for appointment in appointments {
            params.append(appointment.toDictionary())
        }
        return params
    }
}

//"appointment": {
//  "id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//  "notes": "had a surgery last month",
//  "price": 5000000,
//  "state": "done",
//  "visit_time": "2020-10-20 17:05:30",
//  "disease": "checkup",
//  "is_deleted": false,
//  "clinic_id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//  "allergies": "peanut butter",
//  "patient_id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//  "full_name": "John Smith",
//  "phone": "09123456789"
//}
