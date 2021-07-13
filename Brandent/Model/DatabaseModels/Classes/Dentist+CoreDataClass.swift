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
        
        let dentist = Info.sharedInstance.dataController!.createDentist(id: id, firstName: firstName, lastName: lastName, phone: phone, speciality: speciality)
        return dentist
    }
    
    static func getDentistByID(_ id: NSDecimalNumber) -> Dentist? {
        if let object = Info.sharedInstance.dataController?.fetchDentist(id: id), let dentist = object as? Dentist {
            return dentist
        }
        return nil
    }
    
    static func getDentistByPhone(_ phone: String) -> Dentist? {
        if let object = Info.sharedInstance.dataController?.fetchDentist(phone: phone), let dentist = object as? Dentist {
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
    
    func updateDentist(id: NSDecimalNumber, firstName: String, lastName: String, phone: String, speciality: String) {
        setAttributes(id: id, firstName: firstName, lastName: lastName, phone: phone, speciality: speciality)
        Info.sharedInstance.dataController?.saveContext()
    }
    
    func setClinic(clinicTitle: String) {
        let clinic = Clinic.getClinic(id: nil, title: clinicTitle, address: nil, color: nil, isDeleted: nil, modifiedTime: Date())
        Info.sharedInstance.dataController?.setDentistClinic(dentist: self, clinic: clinic)
    }
    
    func setProfilePicture(photo: Image, fromAPI: Bool) {
        Info.sharedInstance.dataController?.setDentistPhoto(dentist: self, photo: photo)
        if !fromAPI {
            RestAPIManagr.sharedInstance.setProfilePicture(photo: [photo])
            self.setModifiedTime()
        }
    }
    
    func setModifiedTime() {
        self.modified_at = Date()
    }
}
