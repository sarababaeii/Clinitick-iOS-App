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

@available(iOS 13.0, *)
@objc(Finance)
public class Finance: NSManagedObject {
    //MARK: Creating object
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
    
    //MARK: Other Functions
    static func getFinancesArray(tag: Int, date: Date) -> [Any]? {
        switch tag {
        case 0:
            return Info.dataController.fetchFinancesAndAppointments(in: date)
        case 1:
            return Info.dataController.fetchAppointmentsInMonth(in: date)
        case 2:
            return Info.dataController.fetchFinanceExternalIncomes(in: date)
        case 3:
            return Info.dataController.fetchFinanceCosts(in: date)
        default:
            return Info.dataController.fetchFinancesAndAppointments(in: date)
        }
    }
    
    static func calculateSum(finances: [Any]) -> Int {
        var sum = 0
        for finance in finances {
            if let item = finance as? Finance {
                if item.is_cost {
                    sum -= Int(truncating: item.amount)
                } else {
                    sum += Int(truncating: item.amount)
                }
            }
            else if let item = finance as? Appointment {
                sum += Int(truncating: item.price)
            }
        }
        return sum
    }
    
    //MARK: Create Dictionary From Object
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
