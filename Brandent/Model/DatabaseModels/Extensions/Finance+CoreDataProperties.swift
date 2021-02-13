//
//  Finance+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Finance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Finance> {
        return NSFetchRequest<Finance>(entityName: "Finance")
    }

    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var is_cost: Bool
    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var dentist: Dentist

}

enum FinanceAttributes: String {
    case id = "id"
    case title = "title"
    case price = "amount"
    case date = "date"
    case isCost = "is_cost"
    case dentist = "dentist"
    case modifiedAt = "modified_at"
}
