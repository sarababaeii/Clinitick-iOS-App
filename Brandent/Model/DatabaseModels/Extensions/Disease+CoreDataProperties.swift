//
//  Disease+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Disease {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Disease> {
        return NSFetchRequest<Disease>(entityName: "Disease")
    }

    @NSManaged public var id: UUID
    @NSManaged public var price: NSDecimalNumber
    @NSManaged public var title: String
    @NSManaged public var modified_at: Date
    @NSManaged public var appointments: NSSet?
    @NSManaged public var dentist: Dentist
}

// MARK: Generated accessors for appointments
extension Disease {

    @objc(addAppointmentsObject:)
    @NSManaged public func addToAppointments(_ value: Appointment)

    @objc(removeAppointmentsObject:)
    @NSManaged public func removeFromAppointments(_ value: Appointment)

    @objc(addAppointments:)
    @NSManaged public func addToAppointments(_ values: NSSet)

    @objc(removeAppointments:)
    @NSManaged public func removeFromAppointments(_ values: NSSet)

}

enum DiseaseAttributes: String {
    case id = "id"
    case title = "title"
    case price = "price"
    case appointments = "appointments"
    case dentist = "dentist"
    case modifiedAt = "modified_at"
}
