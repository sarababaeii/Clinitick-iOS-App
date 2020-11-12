//
//  Clinic+CoreDataClass.swift
//  Brandent
//
//  Created by Sara Babaei on 9/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Clinic)
public class Clinic: NSManagedObject {

    @available(iOS 13.0, *)
    static func getClinic(title: String, address: String?, color: String?) -> Clinic {
        if let clinic = Info.dataController.fetchClinic(title: title) {
            return clinic as! Clinic
        }
        return Info.dataController.createClinic(title: title, address: address, color: color)
    }
    
    func setID() {
        let uuid = UUID()
        self.id = uuid
    }
    
    func setModifiedTime() {
        self.modified_at = Date()
    }
    
    func toDictionary() -> [String: String] {
        var params: [String: String] = [
            APIKey.clinic.id!: self.id.uuidString,
            APIKey.clinic.title!: self.title
        ] //TODO: color
        if let address = self.address {
            params[APIKey.clinic.address!] = address
        }
        return params
    }
    
    static func toDictionaryArray(clinics: [Clinic]) -> [[String: String]] {
        var params = [[String: String]]()
        for clinic in clinics {
            params.append(clinic.toDictionary())
        }
        return params
    }
}

//"clinics": [
//  {
//    "id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//    "title": "khooneye madarbozorg",
//    "address": "Tehran iran shahre tehran"
//  }
//],
