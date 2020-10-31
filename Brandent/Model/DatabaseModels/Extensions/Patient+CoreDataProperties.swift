//
//  Patient+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 10/31/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Patient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patient> {
        return NSFetchRequest<Patient>(entityName: "Patient")
    }

    @NSManaged public var alergies: String?
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var phone: String
    @NSManaged public var history: NSSet?

}

// MARK: Generated accessors for history
extension Patient {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: Appointment)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: Appointment)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}
