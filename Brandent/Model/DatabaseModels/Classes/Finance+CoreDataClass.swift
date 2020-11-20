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
    static func getFinance(id: UUID?, title: String, amount: Int, isCost: Bool, date: Date) -> Finance {
        //is repeated?
        return Info.dataController.createFinance(id: id, title: title, amount: amount, isCost: isCost, date: date)
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
    
    //MARK: API Functions
    func toDictionary() -> [String: String] {
        let params: [String: String] = [
            APIKey.finance.id!: self.id.uuidString,
            APIKey.finance.title!: self.title,
            APIKey.finance.isCost!: String(self.is_cost),
            APIKey.finance.price!: String(Int(truncating: self.amount)),
            APIKey.finance.date!: self.date.toDBFormatDateString(),
            APIKey.finance.isDeleted!: String(self.isDeleted)]
        return params
    }
    
    static func toDictionaryArray(finances: [Finance]) -> [[String: String]] {
        var params = [[String: String]]()
        for finance in finances {
            params.append(finance.toDictionary())
        }
        return params
    }
    
    static func saveFinance(_ finance: NSDictionary) {
        if let idString = finance[APIKey.finance.id!] as? String,
         let id = UUID.init(uuidString: idString),
         let title = finance[APIKey.finance.title!] as? String,
         let priceString = finance[APIKey.finance.price!] as? String,
         let price = Int(priceString),
         let dateString = finance[APIKey.finance.date!] as? String,
         let date = Date.getDBFormatDate(from: dateString),
         let isCostString = finance[APIKey.finance.isCost!] as? String,
         let isCost = Bool(isCostString) {
            let _ = getFinance(id: id, title: title, amount: price, isCost: isCost, date: date)
        }
    } //TODO: set date
}

//"finance": {
//  "id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//  "title": "Ligma",
//  "is_cost": false,
//  "is_deleted": false,
//  "amount": 95000000,
//  "date": "2020-10-9"
//}
