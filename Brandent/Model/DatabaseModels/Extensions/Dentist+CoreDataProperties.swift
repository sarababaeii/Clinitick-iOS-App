//
//  Dentist+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Dentist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dentist> {
        return NSFetchRequest<Dentist>(entityName: "Dentist")
    }

    @NSManaged public var name: Float
    @NSManaged public var phone: String?
    @NSManaged public var photo: Data?
    @NSManaged public var appointments: NSSet?
    @NSManaged public var clinics: NSSet?
    @NSManaged public var diseases: NSSet?
    @NSManaged public var specialities: NSSet?
    @NSManaged public var finances: NSSet?
    @NSManaged public var patients: NSSet?

}

// MARK: Generated accessors for appointments
extension Dentist {

    @objc(addAppointmentsObject:)
    @NSManaged public func addToAppointments(_ value: Appointment)

    @objc(removeAppointmentsObject:)
    @NSManaged public func removeFromAppointments(_ value: Appointment)

    @objc(addAppointments:)
    @NSManaged public func addToAppointments(_ values: NSSet)

    @objc(removeAppointments:)
    @NSManaged public func removeFromAppointments(_ values: NSSet)

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

// MARK: Generated accessors for finances
extension Dentist {

    @objc(addFinancesObject:)
    @NSManaged public func addToFinances(_ value: Finance)

    @objc(removeFinancesObject:)
    @NSManaged public func removeFromFinances(_ value: Finance)

    @objc(addFinances:)
    @NSManaged public func addToFinances(_ values: NSSet)

    @objc(removeFinances:)
    @NSManaged public func removeFromFinances(_ values: NSSet)

}

// MARK: Generated accessors for patients
extension Dentist {

    @objc(addPatientsObject:)
    @NSManaged public func addToPatients(_ value: Patient)

    @objc(removePatientsObject:)
    @NSManaged public func removeFromPatients(_ value: Patient)

    @objc(addPatients:)
    @NSManaged public func addToPatients(_ values: NSSet)

    @objc(removePatients:)
    @NSManaged public func removeFromPatients(_ values: NSSet)

}
