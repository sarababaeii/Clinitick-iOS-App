//
//  Dentist+CoreDataClass.swift
//  Brandent
//
//  Created by Sara Babaei on 12/10/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Dentist)
public class Dentist: NSManagedObject {
    
    static func getDentist(id: UUID?, firstName: String, lastName: String, phone: String, speciality: String, clinicTitle: String, password: String) -> Dentist {
        if let id = id, let dentist = getDentistByID(id) {
            return dentist
        }
        if let dentist = getDentistByPhone(phone) {
            return dentist
        }
        let clinic = Clinic.getClinic(id: nil, title: clinicTitle, address: nil, color: nil)
        let dentist = DataController.sharedInstance.createDentist(id: id, firstName: firstName, lastName: lastName, phone: phone, speciality: speciality, clinic: clinic, password: password)
        Info.sharedInstance.dentistID = dentist.id.uuidString //setting dentist in info
        return dentist
    }
    
    static func getDentistByID(_ id: UUID) -> Dentist? {
        if let object = DataController.sharedInstance.fetchDentist(id: id), let dentist = object as? Dentist {
            return dentist
        }
        return nil
    }
    
    static func getDentistByPhone(_ phone: String) -> Dentist? {
        if let object = DataController.sharedInstance.fetchDentist(phone: phone), let dentist = object as? Dentist {
            return dentist
        }
        return nil
    }
    
    func setAttributes(id: UUID?, firstName: String, lastName: String, phone: String, speciality: String, clinic: Clinic, password: String) {
        self.first_name = firstName
        self.last_name = lastName
        self.phone = phone
        self.speciality = speciality
        self.addToClinics(clinic)
        self.password = password
        
        self.setID(id: id)
        self.setModifiedTime()
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
            APIKey.dentist.phone!: self.phone,
            APIKey.dentist.password!: self.password,
            APIKey.dentist.name! : self.first_name,
            APIKey.dentist.lastName!: self.last_name,
            APIKey.dentist.speciality!: self.speciality]
        return params
    }
}

//{
//  "phone": 9203012037,
//  "password": "DAShnj131nADn",
//  "first_name": "Hutch",
//  "last_name": "The honey bee",
//  "speciality": "جمع کردن عسل"
//}
