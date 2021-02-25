//
//  Patient+CoreDataClass.swift
//  Brandent
//
//  Created by Sara Babaei on 9/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Patient)
public class Patient: Entity {
    //MARK: Initialization
    static func getPatient(id: UUID?, phone: String, name: String, alergies: String?, isDeleted: Bool?, modifiedTime: Date?) -> Patient {
        if let id = id, let patient = getPatientByID(id, isForSync: false) {
            patient.updatePatient(phone: phone, name: name, alergies: alergies, isDeleted: isDeleted, modifiedTime: modifiedTime)
            return patient
        }
        if let patient = getPatientByPhone(phone) {
            patient.updatePatient(phone: phone, name: name, alergies: alergies, isDeleted: isDeleted, modifiedTime: modifiedTime)
            return patient
        }
        return DataController.sharedInstance.createPatient(id: id, name: name, phone: phone, alergies: alergies, isDeleted: isDeleted, modifiedTime: modifiedTime)
    }
    
    static func getPatientByID(_ id: UUID, isForSync: Bool) -> Patient? {
        if let object = DataController.sharedInstance.fetchPatient(id: id, isForSync: isForSync), let patient = object as? Patient {
            return patient
        }
        return nil
    }
    
    static func getPatientByPhone(_ phone: String) -> Patient? { //could be isUnique and generate error
        if let object = DataController.sharedInstance.fetchPatient(phone: phone), let patient = object as? Patient {
            return patient
        }
        return nil
    }
    
    //MARK: Setting Attributes
    func setAttributes(id: UUID?, name: String, phone: String, alergies: String?, isDeleted: Bool?, modifiedTime: Date?) {
        self.name = name
        self.phone = phone
        self.alergies = alergies
        
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
    
    func updatePatient(phone: String?, name: String?, alergies: String?, isDeleted: Bool?, modifiedTime: Date?) {
        setAttributes(id: self.id, name: name ?? self.name, phone: phone ?? self.phone, alergies: alergies, isDeleted: isDeleted, modifiedTime: modifiedTime)
        DataController.sharedInstance.saveContext()
    }
    
    override func delete() {
        self.deleteAppointments()
        super.delete()
    }
    
    private func deleteAppointments() {
        guard let appointments = self.history else {
            return
        }
        for appointment in appointments {
            if let appointment = appointment as? Appointment {
                appointment.delete()
            }
        }
    }
    
    //MARK: Functions
    func getClinics() -> [Clinic]? {
        guard let appointments = self.history else {
            return nil
        }
        var clinics = [Clinic]()
        for item in appointments {
            if let appointment = item as? Appointment, !appointment.is_deleted {
                let clinic = appointment.clinic
                if !clinics.contains(clinic) {
                    clinics.append(clinic)
                }
            }
        }
        return clinics
    }
    
    //MARK: API Functions
    func toDictionary() -> [String: String] {
        let params: [String: String] = [
            APIKey.patient.id!: self.id.uuidString,
            APIKey.patient.name!: self.name,
            APIKey.patient.phone!: self.phone,
            APIKey.patient.isDeleted!: String(self.is_deleted)]
        return params
    }
    
    static func toDictionaryArray(patients: [Patient]) -> [[String: String]] {
        var params = [[String: String]]()
        for patient in patients {
            params.append(patient.toDictionary())
        }
        return params
    }
    
    static func savePatient(_ patient: NSDictionary, modifiedTime: Date) -> Bool {
        guard let idString = patient[APIKey.patient.id!] as? String,
         let id = UUID.init(uuidString: idString),
         let name = patient[APIKey.patient.name!] as? String,
         let phone = patient[APIKey.patient.phone!] as? String,
         let isDeletedInt = patient[APIKey.patient.isDeleted!] as? Int,
         let isDeleted = Bool.intToBool(value: isDeletedInt) else {
            return false
        }
        let _ = getPatient(id: id, phone: phone, name: name, alergies: nil, isDeleted: isDeleted, modifiedTime: modifiedTime)
        return true
    }
}

//"patients": [
//  {
//    "id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//    "full_name": "Mary J. Blige",
//    "phone": "09203012037"
//  }
//], TODO: alergies
