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
public class Patient: NSManagedObject {
    
    @available(iOS 13.0, *)
    static func getPatient(id: UUID?, phone: String, name: String, alergies: String?) -> Patient {
        if let id = id, let object = Info.dataController.fetchPatient(id: id),
            let patient = object as? Patient {
            return patient
        }
        if let object = Info.dataController.fetchPatient(name: name, phone: phone),
            let patient = object as? Patient{
            return patient
        }
        return Info.dataController.createPatient(id: id, name: name, phone: phone, alergies: alergies)
    }
    
    func setID(id: UUID?) {
        if let id = id {
            self.id = id
        } else {
            let uuid = UUID()
            self.id = uuid
        }
    }
    
    func setModifiedTime() {
        self.modified_at = Date()
    }
    
    //MARK: API Functions
    func toDictionary() -> [String: String] {
        let params: [String: String] = [
            APIKey.patient.id!: self.id.uuidString,
            APIKey.patient.name!: self.name,
            APIKey.patient.phone!: self.phone]
        return params
    }
    
    static func toDictionaryArray(patients: [Patient]) -> [[String: String]] {
        var params = [[String: String]]()
        for patient in patients {
            params.append(patient.toDictionary())
        }
        return params
    }
    
    static func savePatient(_ patient: NSDictionary) {
        if let idString = patient[APIKey.patient.id!] as? String,
         let id = UUID.init(uuidString: idString),
         let name = patient[APIKey.patient.name!] as? String,
         let phone = patient[APIKey.patient.phone!] as? String {
            let _ = getPatient(id: id, phone: phone, name: name, alergies: nil)
        }
    }
}

//"patients": [
//  {
//    "id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//    "full_name": "Mary J. Blige",
//    "phone": "09203012037"
//  }
//],
