//
//  Dentist+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 10/1/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Dentist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dentist> {
        return NSFetchRequest<Dentist>(entityName: "Dentist")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: Float
    @NSManaged public var clinics: NSSet?
    @NSManaged public var diseases: NSSet?
    @NSManaged public var specialities: NSSet?

}

// MARK: Generated accessors for clinics
extension Dentist {

    @objc(addClinicsObject:)
    @NSManaged public func addToClinics(_ value: Clinic)

    @objc(removeClinicsObject:)
    @NSManaged public func removeFromClinics(_ value: Clinic)

    @objc(addClinics:)
    @NSManaged public func addToClinics(_ values: NSSet)

    @objc(removeClinics:)
    @NSManaged public func removeFromClinics(_ values: NSSet)

}

// MARK: Generated accessors for diseases
extension Dentist {

    @objc(addDiseasesObject:)
    @NSManaged public func addToDiseases(_ value: Disease)

    @objc(removeDiseasesObject:)
    @NSManaged public func removeFromDiseases(_ value: Disease)

    @objc(addDiseases:)
    @NSManaged public func addToDiseases(_ values: NSSet)

    @objc(removeDiseases:)
    @NSManaged public func removeFromDiseases(_ values: NSSet)

}

// MARK: Generated accessors for specialities
extension Dentist {

    @objc(addSpecialitiesObject:)
    @NSManaged public func addToSpecialities(_ value: Speciality)

    @objc(removeSpecialitiesObject:)
    @NSManaged public func removeFromSpecialities(_ value: Speciality)

    @objc(addSpecialities:)
    @NSManaged public func addToSpecialities(_ values: NSSet)

    @objc(removeSpecialities:)
    @NSManaged public func removeFromSpecialities(_ values: NSSet)

}
