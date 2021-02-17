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
    //MARK: Initialization
    static func getDentist(id: NSDecimalNumber, firstName: String, lastName: String, phone: String, speciality: String) -> Dentist {
        if let dentist = getDentistByID(id) {
            return dentist
        }
        if let dentist = getDentistByPhone(phone) {
            return dentist
        }
        
        let dentist = DataController.sharedInstance.createDentist(id: id, firstName: firstName, lastName: lastName, phone: phone, speciality: speciality)
        return dentist
    }
    
    static func getDentistByID(_ id: NSDecimalNumber) -> Dentist? {
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
    
    //MARK: Setting Attributes
    func setAttributes(id: NSDecimalNumber, firstName: String, lastName: String, phone: String, speciality: String) {
        self.id = id
        self.first_name = firstName
        self.last_name = lastName
        self.phone = phone
        self.speciality = speciality
        
        self.setModifiedTime()
    }
    
    func setClinic(clinicTitle: String) {
        let clinic = Clinic.getClinic(id: nil, title: clinicTitle, address: nil, color: nil)
        DataController.sharedInstance.setDentistClinic(dentist: self, clinic: clinic)
    }
    
    func setProfilePicture(photo: Image, fromAPI: Bool) {
        DataController.sharedInstance.setDentistPhoto(dentist: self, photo: photo)
        if !fromAPI {
            self.setModifiedTime()
        }
    }
    
    func setModifiedTime() {
        self.modified_at = Date()
    }
}
