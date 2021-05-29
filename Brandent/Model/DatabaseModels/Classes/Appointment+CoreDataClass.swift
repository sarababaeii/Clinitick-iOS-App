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
    static func createAppointment(id: UUID, patientID: UUID, clinicID: UUID, disease: String, price: Int?, date: Date?, tooth: String, state: String, isDeleted: Bool, modifiedTime: Date) -> Appointment? { // for sync
        guard let clinic = Clinic.getClinicByID(clinicID, isForSync: true) else {
            print("clinic $\(clinicID) did not find")
            return nil
        }
        guard let patient = Patient.getPatientByID(patientID, isForSync: true) else {
            print("patient $\(clinicID) did not find")
            return nil
        }
        if let appointment = getAppointmentByID(id) {
            appointment.updateAppointment(id: id, patient: patient, disease: disease, price: price, visit_time: date, clinic: clinic, tooth: tooth, state: state, isDeleted: isDeleted, modifiedTime: modifiedTime)
            return appointment
        }
        return createAppointment(id: id, patient: patient, clinic: clinic, disease: disease, price: price, date: date, tooth: tooth, state: state, isDeleted: isDeleted, modifiedTime: modifiedTime)
    }
    
    static func createAppointment(id: UUID?, patient: Patient, clinic: Clinic, disease: String, price: Int?, date: Date?, tooth: String, state: String, isDeleted: Bool?, modifiedTime: Date?) -> Appointment {
        if let id = id, let appointment = getAppointmentByID(id) { // for add
            appointment.updateAppointment(id: id, patient: patient, disease: disease, price: price, visit_time: date, clinic: clinic, tooth: tooth, state: state, isDeleted: nil, modifiedTime: Date())
            return appointment
        }
        let appointment = Info.sharedInstance.dataController!.createAppointment(id: id, patient: patient, disease: disease, price: price, visit_time: date, clinic: clinic, tooth: tooth, state: state, isDeleted: isDeleted, modifiedTime: modifiedTime)
        UserNotificationManager.sharedInstance.scheduleNotificationForAppointment(appointment: appointment)
        return appointment
    }
    
    static func getAppointmentByID(_ id: UUID) -> Appointment? {
        if let object = Info.sharedInstance.dataController?.fetchAppointment(id: id), let appointment = object as? Appointment {
            return appointment
        }
        return nil
    }
    
    //MARK: Setting Attributes
    func setAttributes(id: UUID?, patient: Patient, disease: String, price: Int?, visit_time: Date?, clinic: Clinic, tooth: String, state: String, isDeleted: Bool?, modifiedTime: Date?) {
        if let price = price {
            self.price = NSDecimalNumber(value: price)
        }
        if let visit_time = visit_time {
            self.visit_time = visit_time
        } else {
            self.visit_time = Date.defaultDate()
        }
        self.disease = disease
        self.tooth = tooth
        self.state = state
        self.clinic = clinic
        self.patient = patient
        
        self.setID(id: id)
        self.setDentist()
        if let isDeleted = isDeleted, let date = modifiedTime {
            self.setDeleteAttributes(to: isDeleted, at: date)
        }
        self.setModifiedTime(at: modifiedTime)
    }
    
    func setDentist() {
        if let dentist = Info.sharedInstance.dentist {
            self.dentist = dentist
        }
    }
    
    override func delete(to isDeleted: Bool) {
        super.delete(to: isDeleted)
        UserNotificationManager.sharedInstance.removeNotoficationForAppointment(appointment: self)
    }
    
    func updateAppointment(id: UUID?, patient: Patient, disease: String, price: Int?, visit_time: Date?, clinic: Clinic, tooth: String, state: String, isDeleted: Bool?, modifiedTime: Date?) {
        setAttributes(id: id, patient: patient, disease: disease, price: price, visit_time: visit_time, clinic: clinic, tooth: tooth, state: state, isDeleted: isDeleted, modifiedTime: modifiedTime)
        Info.sharedInstance.dataController?.saveContext()
        UserNotificationManager.sharedInstance.updateNotificationForAppointment(appointment: self)
    }
    
    func updateState(state: TaskState) -> Bool {
        if self.state == state.rawValue {
            self.state = TaskState.todo.rawValue
        } else {
            self.state = state.rawValue
        }
        self.setModifiedTime(at: Date())
        Info.sharedInstance.dataController?.saveContext()
        return self.state == state.rawValue
    }
    
    //MARK: Functions
    static func sort(appointments: [Appointment]?, others: [Entity]?) -> [Entity]? {
        guard let appointments = appointments else {
            return others //could be nil
        }
        guard let others = others else {
            return appointments
        }
        var mixture = [Entity]()
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
    }
    
    static func removeAppointmentsWithoutPrice(entities: [Entity]?) -> [Entity]? {
        guard let entities = entities else {
            return nil
        }
        var array = entities
        var i = 0
        while i < array.count {
            if let appointment = array[i] as? Appointment, appointment.price == -1 {
                array.remove(at: i)
                i -= 1
            }
            i += 1
        }
        return array
    }
    
    //MARK: API Functions
    func toDictionary() -> [String: String] {
        let params = [
            APIKey.appointment.id!: self.id.uuidString,
            APIKey.appointment.price!: String(Int(truncating: self.price)),
            APIKey.appointment.state!: self.state,
            APIKey.appointment.date!: self.visit_time.toDBFormatDateAndTimeString(isForSync: false),
            APIKey.appointment.disease!: self.disease,
            APIKey.appointment.tooth!: self.tooth,
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
    
    static func saveAppointment(_ appointment: NSDictionary, modifiedTime: Date) -> Bool {
        guard let idString = appointment[APIKey.appointment.id!] as? String,
         let id = UUID.init(uuidString: idString), // id
         let patientIDString = appointment[APIKey.appointment.patient!] as? String,
         let patientID = UUID.init(uuidString: patientIDString), // patient
         let disease = appointment[APIKey.appointment.disease!] as? String, // disease
         let priceString = appointment[APIKey.appointment.price!] as? String,
         let price = Int(priceString), // price could be 0
         let dateString = appointment[APIKey.appointment.date!] as? String,
         let date = Date.getDBFormatDate(from: dateString, isForSync: false), // visit time could be default date
         let clinicIDString = appointment[APIKey.appointment.clinic!] as? String,
         let clinicID = UUID.init(uuidString: clinicIDString), // clinic
         let state = appointment[APIKey.appointment.state!] as? String, // state
         let tooth = appointment[APIKey.appointment.tooth!] as? String, // tooth
         let isDeletedInt = appointment[APIKey.appointment.isDeleted!] as? Int,
         let isDeleted = Bool.intToBool(value: isDeletedInt) else {
            return false
        }
        if let _ = createAppointment(id: id, patientID: patientID, clinicID: clinicID, disease: disease, price: price, date: date, tooth: tooth, state: state, isDeleted: isDeleted, modifiedTime: modifiedTime) {
            print("#\(id)")
            return true
        }
        return false
    }
}

//"appointments": {
//    "id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//    "price": 5000000,
//    "state": "done",
//    "visit_time": "2020-10-20 17:05:30",
//    "disease": "checkup",
//    "tooth": "UL8, Upper Left 8",
//    "is_deleted": false,
//    "clinic_id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//    "allergies": "peanut butter",
//    "patient_id": "890a32fe-12e6-11eb-adc1-0242ac120002"
//  }
