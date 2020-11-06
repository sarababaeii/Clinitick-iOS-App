//
//  Speciality+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Speciality {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Speciality> {
        return NSFetchRequest<Speciality>(entityName: "Speciality")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var dentist: Dentist?
    @NSManaged public var diseases: NSSet?

}

// MARK: Generated accessors for diseases
extension Speciality {

    @objc(addDiseasesObject:)
    @NSManaged public func addToDiseases(_ value: Disease)

    @objc(removeDiseasesObject:)
    @NSManaged public func removeFromDiseases(_ value: Disease)

    @objc(addDiseases:)
    @NSManaged public func addToDiseases(_ values: NSSet)

    @objc(removeDiseases:)
    @NSManaged public func removeFromDiseases(_ values: NSSet)

}
