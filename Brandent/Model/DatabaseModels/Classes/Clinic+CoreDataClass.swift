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
    static func getClinic(id: UUID?, title: String, address: String?, color: String?) -> Clinic {
        if let id = id, let object = Info.dataController.fetchClinic(id: id),
            let clinic = object as? Clinic {
            return clinic
        }
        if let object = Info.dataController.fetchClinic(title: title),
            let clinic = object as? Clinic {
            return clinic
        }
        return Info.dataController.createClinic(id: id, title: title, address: address, color: color)
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
        var params: [String: String] = [
            APIKey.clinic.id!: self.id.uuidString,
            APIKey.clinic.title!: self.title,
            APIKey.clinic.color! : self.color]
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
    
    static func saveClinic(_ clinic: NSDictionary) {
        guard let idString = clinic[APIKey.clinic.id!] as? String,
         let id = UUID.init(uuidString: idString),
         let title = clinic[APIKey.clinic.title!] as? String,
         let color = clinic[APIKey.clinic.color!] as? String else {
           return
        }
        var address: String?
        if let add = clinic[APIKey.clinic.address!] as? String {
            address = add
        }
        let _ = getClinic(id: id, title: title, address: address, color: color)
    }
}

//"clinic": {
//  "id": "3b155280-1a49-11eb-bd07-7d22de018431",
//  "title": "khooneye madarbozorg",
//  "address": "Tehran iran shahre tehran",
//  "color": "#abcdef"
//}
