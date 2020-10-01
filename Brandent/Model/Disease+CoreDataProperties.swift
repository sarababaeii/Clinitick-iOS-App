//
//  Disease+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 10/1/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Disease {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Disease> {
        return NSFetchRequest<Disease>(entityName: "Disease")
    }

    @NSManaged public var id: NSDecimalNumber?
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var title: String?
    @NSManaged public var appointments: NSSet?
    @NSManaged public var dentist: Dentist?
    @NSManaged public var specialities: NSSet?

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

// MARK: Generated accessors for specialities
extension Disease {

    @objc(addSpecialitiesObject:)
    @NSManaged public func addToSpecialities(_ value: Speciality)

    @objc(removeSpecialitiesObject:)
    @NSManaged public func removeFromSpecialities(_ value: Speciality)

    @objc(addSpecialities:)
    @NSManaged public func addToSpecialities(_ values: NSSet)

    @objc(removeSpecialities:)
    @NSManaged public func removeFromSpecialities(_ values: NSSet)

}
