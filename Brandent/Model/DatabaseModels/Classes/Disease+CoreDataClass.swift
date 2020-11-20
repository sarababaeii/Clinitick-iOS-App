//
//  Disease+CoreDataClass.swift
//  Brandent
//
//  Created by Sara Babaei on 9/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Disease)
public class Disease: NSManagedObject {
    
    @available(iOS 13.0, *)
    static func getDisease(id: UUID?, title: String, price: Int) -> Disease {
        if let id = id, let object = Info.dataController.fetchDisease(id: id),
            let disease = object as? Disease {
            return disease
        }
        if let object = Info.dataController.fetchDisease(title: title),
            let disease = object as? Disease{
            return disease
        }
        return Info.dataController.createDisease(id: id, title: title, price: price)
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
    
    static func saveDiseaseArray(diseases: NSArray) {
        for item in diseases {
            if let disease = item as? NSDictionary {
                saveDisease(disease)
            }
        }
    }
    //MARK: API Functions
    func toDictionary() -> [String: String] {
        let params: [String: String] = [
            APIKey.disease.id!: self.id.uuidString,
            APIKey.disease.title!: self.title,
            APIKey.disease.price!: String(Int(truncating: self.price))]
        return params
    }
    
    static func toDictionaryArray(diseases: [Disease]) -> [[String: String]] {
        var params = [[String: String]]()
        for disease in diseases {
            params.append(disease.toDictionary())
        }
        return params
    }
    
    static func saveDisease(_ disease: NSDictionary) {
        if let idString = disease[APIKey.disease.id!] as? String,
         let id = UUID.init(uuidString: idString),
         let title = disease[APIKey.disease.title!] as? String,
         let priceString = disease[APIKey.disease.price!] as? String,
         let price = Int(priceString) {
            let _ = getDisease(id: id, title: title, price: price)
        }
    }
}

//"diseases": [
//  {
//    "id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//    "title": "sine saratan",
//    "price": 50000000
//  }
//],
