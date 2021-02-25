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
public class Finance: Entity {
    //MARK: Initialization
    static func getFinance(id: UUID?, title: String, amount: Int, isCost: Bool, date: Date, isDeleted: Bool?, modifiedTime: Date?) -> Finance {
        if let id = id, let object = DataController.sharedInstance.fetchFinance(id: id),
            let finance = object as? Finance {
            finance.updateFinance(id: id, title: title, amount: amount, isCost: isCost, date: date, isDeleted: isDeleted, modifiedTime: modifiedTime)
            return finance
        }
        return DataController.sharedInstance.createFinance(id: id, title: title, amount: amount, isCost: isCost, date: date, isDeleted: isDeleted, modifiedTime: modifiedTime)
    }
    
    //MARK: Setting Attributes
    func setAttributes(id: UUID?, title: String, amount: Int, isCost: Bool, date: Date, isDeleted: Bool?, modifiedTime: Date?) {
        self.title = title
        self.amount = NSDecimalNumber(value: amount)
        self.is_cost = isCost
        self.date = date
        
        self.setID(id: id)
        self.setDentist()
        if let isDeleted = isDeleted, let date = modifiedTime {
            self.setDeleteAttributes(to: isDeleted, at: date)
        }
        self.setModifiedTime(at: modifiedTime)
    }
    
    func setDentist() {
        if let dentist = Info.sharedInstance.dentist {
            self.dentist = dentist
        }
    }
    
    func updateFinance(id: UUID?, title: String, amount: Int, isCost: Bool, date: Date, isDeleted: Bool?, modifiedTime: Date?) {
        setAttributes(id: id, title: title, amount: amount, isCost: isCost, date: date, isDeleted: isDeleted, modifiedTime: modifiedTime)
        DataController.sharedInstance.saveContext()
    }
    
    func getAmount() -> Int {
        if self.is_cost {
            return Int(truncating: self.amount) * -1
        }
        return Int(truncating: self.amount)
    }
    
    //MARK: Functions
    static func getFinancesArray(tag: Int, date: Date) -> [Entity]? {
        switch tag {
        case 0:
            let entities = DataController.sharedInstance.fetchFinancesAndAppointments(in: date) as? [Entity]
            return Appointment.removeAppointmentsWithoutPrice(entities: entities)
        case 1:
            let appointments = DataController.sharedInstance.fetchAppointmentsInMonth(in: date) as? [Entity]
            return Appointment.removeAppointmentsWithoutPrice(entities: appointments)
        case 2:
            return DataController.sharedInstance.fetchFinanceExternalIncomes(in: date) as? [Entity]
        case 3:
            return DataController.sharedInstance.fetchFinanceCosts(in: date) as? [Entity]
        default:
            return DataController.sharedInstance.fetchFinancesAndAppointments(in: date) as? [Entity]
        }
    }
    
    static func calculateSum(finances: [Entity]?) -> Int {
        var sum = 0
        if let finances = finances {
            for finance in finances {
                if let item = finance as? Finance {
                    sum += item.getAmount()
                }
                else if let item = finance as? Appointment {
                    sum += Int(truncating: item.price)
                }
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
            APIKey.finance.isDeleted!: String(self.is_deleted)]
        return params
    }
    
    static func toDictionaryArray(finances: [Finance]) -> [[String: String]] {
        var params = [[String: String]]()
        for finance in finances {
            params.append(finance.toDictionary())
        }
        return params
    }
    
    static func saveFinance(_ finance: NSDictionary, modifiedTime: Date) -> Bool {
        guard let idString = finance[APIKey.finance.id!] as? String,
         let id = UUID.init(uuidString: idString),
         let title = finance[APIKey.finance.title!] as? String,
         let priceString = finance[APIKey.finance.price!] as? String,
         let price = Int(priceString),
         let dateString = finance[APIKey.finance.date!] as? String,
            let date = Date.getDBFormatDate(from: dateString, isForSync: false),
         let isCostString = finance[APIKey.finance.isCost!] as? Int,
         let isCost = Bool.intToBool(value: isCostString),
         let isDeletedInt = finance[APIKey.finance.isDeleted!] as? Int,
         let isDeleted = Bool.intToBool(value: isDeletedInt) else {
            return false
        }
        let _ = getFinance(id: id, title: title, amount: price, isCost: isCost, date: date, isDeleted: isDeleted, modifiedTime: modifiedTime)
        return true
    }
}

//"finance": {
//  "id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//  "title": "Ligma",
//  "is_cost": false,
//  "is_deleted": false,
//  "amount": 95000000,
//  "date": "2020-10-9"
//}
