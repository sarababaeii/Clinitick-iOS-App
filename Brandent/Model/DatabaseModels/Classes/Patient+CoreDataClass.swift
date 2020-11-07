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
//    init(name: Float, phone: Float) {
//        super.init()
//        self.name = name
//        self.phone = phone
//    }
}
