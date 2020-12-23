//
//  Clinic+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 12/18/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Clinic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Clinic> {
        return NSFetchRequest<Clinic>(entityName: "Clinic")
    }

    @NSManaged public var address: String?
    @NSManaged public var color: String
    @NSManaged public var id: UUID
    @NSManaged public var modified_at: Date
    @NSManaged public var title: String
    @NSManaged public var appointments: NSSet?
    @NSManaged public var dentist: Dentist
    @NSManaged public var tasks: NSSet?
    @NSManaged public var patients: NSSet?

}

// MARK: Generated accessors for appointments
extension Clinic {

    @objc(addAppointmentsObject:)
    @NSManaged public func addToAppointments(_ value: Appointment)

    @objc(removeAppointmentsObject:)
    @NSManaged public func removeFromAppointments(_ value: Appointment)

    @objc(addAppointments:)
    @NSManaged public func addToAppointments(_ values: NSSet)

    @objc(removeAppointments:)
    @NSManaged public func removeFromAppointments(_ values: NSSet)

}

// MARK: Generated accessors for tasks
extension Clinic {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

// MARK: Generated accessors for patients
extension Clinic {

    @objc(addPatientsObject:)
    @NSManaged public func addToPatients(_ value: Patient)

    @objc(removePatientsObject:)
    @NSManaged public func removeFromPatients(_ value: Patient)

    @objc(addPatients:)
    @NSManaged public func addToPatients(_ values: NSSet)

    @objc(removePatients:)
    @NSManaged public func removeFromPatients(_ values: NSSet)

}

enum ClinicAttributes: String {
    case id = "id"
    case title = "title"
    case address = "address"
    case color = "color"
    case appointments = "appointments"
    case tasks = "tasks"
    case patients = "patients"
    case dentist = "dentist"
    case modifiedAt = "modified_at"
}
