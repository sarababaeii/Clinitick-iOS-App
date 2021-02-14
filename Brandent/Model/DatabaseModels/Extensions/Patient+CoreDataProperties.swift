//
//  Patient+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 12/18/20.
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
    @NSManaged public var name: String
    @NSManaged public var phone: String
    @NSManaged public var dentist: Dentist
    @NSManaged public var history: NSSet?
    @NSManaged public var clinics: NSSet?

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

enum PatientAttributes: String {
    case id = "id"
    case name = "name"
    case phone = "phone"
    case alergies = "alergies"
    case clinics = "clinics"
    case images = "images"
    case history = "history"
    case dentist = "dentist"
    case modifiedAt = "modified_at"
}
