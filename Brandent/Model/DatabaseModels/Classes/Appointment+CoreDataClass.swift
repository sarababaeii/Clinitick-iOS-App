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
public class Appointment: Entity {
    //MARK: Initialization
    static func createAppointment(id: UUID, patientID: UUID, clinicID: UUID, disease: String, price: Int?, date: Date?, state: String) -> Appointment { // for sync
        if let appointment = getAppointmentByID(id) {
//            appointment.updateAppointment(id: id, patient: patient, disease: disease, price: price, visit_time: date, clinic: clinic)
            return appointment
        }
        let clinic = Clinic.getClinicByID(clinicID)!
        let patient = Patient.getPatientByID(patientID)! //TODO: safe unwrapping
        return createAppointment(id: id, patient: patient, clinic: clinic, disease: disease, price: price, date: date, state: state)
    }
    
    static func createAppointment(id: UUID?, patient: Patient, clinic: Clinic, disease: String, price: Int?, date: Date?, state: String) -> Appointment {
        if let id = id, let appointment = getAppointmentByID(id) { // for add
            appointment.updateAppointment(id: id, patient: patient, disease: disease, price: price, visit_time: date, clinic: clinic, state: state)
            return appointment
        }
        return DataController.sharedInstance.createAppointment(id: id, patient: patient, disease: disease, price: price, visit_time: date, clinic: clinic, state: state)
    }
    
    static func getAppointmentByID(_ id: UUID) -> Appointment? {
        if let object = DataController.sharedInstance.fetchAppointment(id: id), let appointment = object as? Appointment {
            return appointment
        }
        return nil
    }
    
    //MARK: Setting Attributes
    func setAttributes(id: UUID?, patient: Patient, disease: String, price: Int?, visit_time: Date?, clinic: Clinic, state: String) {
        if let price = price {
            self.price = NSDecimalNumber(value: price)
        }
        if let visit_time = visit_time {
            self.visit_time = visit_time
        }
        self.state = state //TaskState.todo.rawValue //should set
        self.clinic = clinic
        self.patient = patient
        self.disease = disease
      
        self.setID(id: id)
        self.setDentist()
        self.setModifiedTime()
    }
    
    func setDentist() {
        if let dentist = Info.sharedInstance.dentist {
            self.dentist = dentist
        }
    }
    
    func updateAppointment(id: UUID?, patient: Patient, disease: String, price: Int?, visit_time: Date?, clinic: Clinic, state: String) {
        setAttributes(id: id, patient: patient, disease: disease, price: price, visit_time: visit_time, clinic: clinic, state: state)
        DataController.sharedInstance.saveContext()
    }
    
    func updateState(state: TaskState) {
        self.state = state.rawValue
        self.setModifiedTime()
        DataController.sharedInstance.saveContext()
    }
    
    //MARK: Functions
    static func sort(appointments: [Appointment]?, others: [NSManagedObject]?) -> [NSManagedObject]? {
        guard let appointments = appointments else {
            return others //could be nil
        }
        guard let others = others else {
            return appointments
        }
        var mixture = [NSManagedObject]()
        var appoinmentPointer = 0
        var otherPointer = 0
        
        while mixture.count < appointments.count + others.count {
            if appoinmentPointer >= appointments.count {
                mixture.append(others[otherPointer])
                otherPointer += 1
            } else if otherPointer >= others.count {
                mixture.append(appointments[appoinmentPointer])
                appoinmentPointer += 1
            } else {
                if let finance = others[otherPointer] as? Finance, appointments[appoinmentPointer].visit_time < finance.date {
                mixture.append(appointments[appoinmentPointer])
                appoinmentPointer += 1
                } else if let task = others[otherPointer] as? Task, appointments[appoinmentPointer].visit_time < task.date {
                    mixture.append(appointments[appoinmentPointer])
                    appoinmentPointer += 1
                }
                else {
                    mixture.append(others[otherPointer])
                    otherPointer += 1
                }
            }
        }
        return mixture
    } //should be tested
    
    //MARK: API Functions
    func toDictionary() -> [String: String] {
        let params = [
            APIKey.appointment.id!: self.id.uuidString,
            APIKey.appointment.price!: String(Int(truncating: self.price)),
            APIKey.appointment.state!: self.state,
            APIKey.appointment.date!: self.visit_time.toDBFormatDateAndTimeString(),
            APIKey.appointment.disease!: self.disease,
            APIKey.appointment.isDeleted!: String(self.is_deleted),
            APIKey.appointment.patient!: self.patient.id.uuidString,
            APIKey.appointment.clinic!: self.clinic.id.uuidString]
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
         let patientIDString = appointment[APIKey.appointment.patient!] as? String,
         let patientID = UUID.init(uuidString: patientIDString),
         let disease = appointment[APIKey.appointment.disease!] as? String,
         let priceString = appointment[APIKey.appointment.price!] as? String,
         let price = Int(priceString),
         let dateString = appointment[APIKey.appointment.date!] as? String,
         let date = Date.getDBFormatDate(from: dateString),
         let clinicIDString = appointment[APIKey.appointment.clinic!] as? String,
         let clinicID = UUID.init(uuidString: clinicIDString) else {
            return
        }
        let _ = createAppointment(id: id, patientID: patientID, clinicID: clinicID, disease: disease, price: price, date: date, state: TaskState.todo.rawValue) //TODO: State
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
//  "patient_id": "890a32fe-12e6-11eb-adc1-0242ac120002"
//}
