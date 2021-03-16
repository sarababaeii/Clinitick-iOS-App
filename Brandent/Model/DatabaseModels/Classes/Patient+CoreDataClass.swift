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
        return (Info.sharedInstance.dataController?.createPatient(id: id, name: name, phone: phone, alergies: alergies, isDeleted: isDeleted, modifiedTime: modifiedTime))!
    }
    
    static func getPatientByID(_ id: UUID, isForSync: Bool) -> Patient? {
        if let object = Info.sharedInstance.dataController?.fetchPatient(id: id, isForSync: isForSync), let patient = object as? Patient {
            return patient
        }
        return nil
    }
    
    static func getPatientByPhone(_ phone: String) -> Patient? { //could be isUnique and generate error
        if let object = Info.sharedInstance.dataController?.fetchPatient(phone: phone), let patient = object as? Patient {
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
        Info.sharedInstance.dataController?.saveContext()
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
    
    static func getAllergyString(allergies: [String]) -> String {
        var allergyString = ""
        for allergy in allergies {
            allergyString += (allergy + ",")
        }
        return allergyString
    }
    
    func getAllergyArray(allergies: String) -> [String] {
        var allergyArray = [String]()
        let allergiesSplitted = allergies.split(separator: ",")
        for allergy in allergiesSplitted {
            allergyArray.append(String(allergy))
        }
        return allergyArray
    }
    
    //MARK: API Functions
    func toDictionary() -> [String: Any] {
        var params: [String: Any] = [
            APIKey.patient.id!: self.id.uuidString,
            APIKey.patient.name!: self.name,
            APIKey.patient.phone!: self.phone,
            APIKey.patient.isDeleted!: String(self.is_deleted)]
        if let allergies = self.alergies {
            params[APIKey.patient.allergies!] = getAllergyArray(allergies: allergies)
        }
        return params
    }
    
    static func toDictionaryArray(patients: [Patient]) -> [[String: Any]] {
        var params = [[String: Any]]()
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
        var allergies: String?
        if let allergiesArray = patient[APIKey.patient.allergies!] as? [String] {
            allergies = getAllergyString(allergies: allergiesArray)
        }
        let _ = getPatient(id: id, phone: phone, name: name, alergies: allergies, isDeleted: isDeleted, modifiedTime: modifiedTime)
        print("#\(id)")
        return true
    }
}

//"patients": [
//  {
//    "id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//    "full_name": "Mary J. Blige",
//    "allergies": [
//      "a",
//      "b",
//      "c"
//    ],
//    "phone": "09203012037",
//    "is_deleted": false
//  }
//]
