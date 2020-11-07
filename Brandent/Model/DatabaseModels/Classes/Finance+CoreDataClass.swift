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
}
