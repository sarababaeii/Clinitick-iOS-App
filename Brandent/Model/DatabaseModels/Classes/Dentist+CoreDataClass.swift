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
  
    @available(iOS 13.0, *)
    static func getDentist(id: UUID?, firstName: String, lastName: String, phone: String, speciality: String, password: String) -> Dentist {
        if let id = id, let object = Info.dataController.fetchDentist(id: id),
            let dentist = object as? Dentist {
            return dentist
        }
        if let object = Info.dataController.fetchDentist(phone: phone),
            let dentist = object as? Dentist {
            return dentist
        }
        return Info.dataController.createDentist(id: id, firstName: firstName, lastName: lastName, phone: phone, speciality: speciality, password: password)
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

//    static func toDictionaryArray(clinics: [Clinic]) -> [[String: String]] {
//        var params = [[String: String]]()
//        for clinic in clinics {
//            params.append(clinic.toDictionary())
//        }
//        return params
//    }
//
//    static func saveClinic(_ clinic: NSDictionary) {
//        guard let idString = clinic[APIKey.clinic.id!] as? String,
//         let id = UUID.init(uuidString: idString),
//         let title = clinic[APIKey.clinic.title!] as? String,
//         let color = clinic[APIKey.clinic.color!] as? String else {
//           return
//        }
//        var address: String?
//        if let add = clinic[APIKey.clinic.address!] as? String {
//            address = add
//        }
//        let _ = getClinic(id: id, title: title, address: address, color: color)
//    }
}

//{
//  "phone": 9203012037,
//  "password": "DAShnj131nADn",
//  "first_name": "Hutch",
//  "last_name": "The honey bee",
//  "speciality": "جمع کردن عسل"
//}
