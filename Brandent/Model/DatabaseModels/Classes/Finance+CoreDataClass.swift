//
//  Finance+CoreDataClass.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Finance)
public class Finance: NSManagedObject {

//    required convenience public init(from decoder: Decoder) throws {
//        self.init()
//    }
    
    @available(iOS 13.0, *)
    static func getFinance(title: String, amount: Int, isCost: Bool, date: Date) -> Finance {
        //is repeated?
        return Info.dataController.createFinance(title: title, amount: amount, isCost: isCost, date: date)
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
            APIKey.finance.id!: self.id.uuidString,
            APIKey.dentist.id!: "1",
            APIKey.finance.title!: self.title,
            APIKey.finance.isCost!: String(self.is_cost),
            APIKey.finance.price!: String(Int(truncating: self.amount)),
            APIKey.finance.date!: self.date.toDBFormatDateString(),
            APIKey.finance.isDeleted!: String(self.isDeleted)
        ]
        return params
    }
    
    static func toDictionaryArray(finances: [Finance]) -> [[String: String]] {
        var params = [[String: String]]()
        for finance in finances {
            params.append(finance.toDictionary())
        }
        return params
    }
}

//"finances": [
//  {
//    "id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//    "dentist_id": 1,
//    "title": "Ligma",
//    "is_cost": false,
//    "amount": 95000000,
//    "date": "2020-10-9"
//  }
//],
