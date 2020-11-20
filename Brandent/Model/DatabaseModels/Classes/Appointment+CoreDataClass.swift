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
    static func createAppointment(id: UUID, name: String, phone: String, diseaseTitle: String, price: Int, clinicTitle: String?, alergies: String?, visit_time: Date, notes: String?) -> Appointment {
        var clinic: Clinic?
        if let clinicTitle = clinicTitle {
            clinic = Clinic.getClinic(id: nil, title: clinicTitle, address: nil, color: nil)
        }
        let patient = Patient.getPatient(id: nil, phone: phone, name: name, alergies: alergies)
        let disease = Disease.getDisease(id: nil, title: diseaseTitle, price: price)
        return Info.dataController.createAppointment(id: id, patient: patient, disease: disease, price: price, visit_time: visit_time, clinic: clinic, alergies: alergies, notes: notes)
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
    
    func setID(id: UUID?) {
        if let id = id {
            self.id = id
        } else {
            let uuid = UUID()
            self.id = uuid
        }
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
    
    //MARK: API Functions
    func toDictionary() -> [String: String] {
        var params = [
            APIKey.appointment.id!: self.id.uuidString,
            APIKey.appointment.price!: String(Int(truncating: self.price)),
            APIKey.appointment.state!: self.state,
            APIKey.appointment.date!: self.visit_time.toDBFormatDateAndTimeString(),
            APIKey.appointment.disease!: self.disease.title,
            APIKey.appointment.isDeleted!: String(self.isDeleted), //test
            APIKey.appointment.patient!: self.patient.id.uuidString]
        if let notes = self.notes {
            params[APIKey.appointment.notes!] = notes
        }
        if let clinic = self.clinic {
            params[APIKey.appointment.clinic!] = clinic.id.uuidString
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
    
    static func saveAppointment(_ appointment: NSDictionary) {
        guard let idString = appointment[APIKey.appointment.id!] as? String,
         let id = UUID.init(uuidString: idString),
         let name = appointment[APIKey.patient.name!] as? String,
         let phone = appointment[APIKey.patient.phone!] as? String,
         let disease = appointment[APIKey.appointment.disease!] as? String,
         let priceString = appointment[APIKey.appointment.price!] as? String,
         let price = Int(priceString),
         let dateString = appointment[APIKey.appointment.date!] as? String,
         let date = Date.getDBFormatDate(from: dateString) else {
            return
        }
//        var clinic: String? // let clinic = appointment[APIKey.appointment.clinic!] as? String,
        var alergies: String?
        var notes: String?

        if let alergy = appointment[APIKey.appointment.alergies!] as? String {
            alergies = alergy
        }
        if let note = appointment[APIKey.appointment.notes!] as? String {
            notes = note
        }
        let _ = createAppointment(id: id, name: name, phone: phone, diseaseTitle: disease, price: price, clinicTitle: nil, alergies: alergies, visit_time: date, notes: notes)
    } //TODO: Set clinic and date
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
//  "patient_id": "890a32fe-12e6-11eb-adc1-0242ac120002"
//}
