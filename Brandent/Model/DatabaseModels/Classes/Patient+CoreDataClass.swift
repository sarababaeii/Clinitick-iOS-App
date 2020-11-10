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
    static func getPatient(phone: String, name: String, alergies: String?) -> Patient {
        if let patient = Info.dataController.fetchPatient(phone: phone) {
            return patient as! Patient
        }
        return Info.dataController.createPatient(name: name, phone: phone, alergies: alergies)
    }
    
    func setID() {
        let uuid = UUID()
        self.id = uuid
    }
    
    func setModifiedTime() {
        self.modified_at = Date()
    }
    
    func toDictionary() -> [String: String] {
        let params: [String: String] = [
            APIKey.patient.id!: self.id.uuidString,
            APIKey.patient.name!: self.name,
            APIKey.patient.phone!: self.phone
        ]
        return params
    }
    
    static func toDictionaryArray(patients: [Patient]) -> [[String: String]] {
        var params = [[String: String]]()
        for patient in patients {
            params.append(patient.toDictionary())
        }
        return params
    }
}

//"patients": [
//  {
//    "id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//    "full_name": "Mary J. Blige",
//    "phone": "09203012037"
//  }
//],
