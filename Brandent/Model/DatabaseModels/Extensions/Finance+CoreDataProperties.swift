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
    @NSManaged public var id: UUID
    @NSManaged public var is_cost: Bool
    @NSManaged public var modified_at: Date
    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var dentist: Dentist?

}
