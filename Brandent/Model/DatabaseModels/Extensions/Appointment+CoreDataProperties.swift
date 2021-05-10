//
//  Appointment+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Appointment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Appointment> {
        return NSFetchRequest<Appointment>(entityName: "Appointment")
    }

    @NSManaged public var price: NSDecimalNumber
    @NSManaged public var state: String
    @NSManaged public var visit_time: Date
    @NSManaged public var disease: String
    @NSManaged public var tooth: String
    @NSManaged public var clinic: Clinic
    @NSManaged public var dentist: Dentist
    @NSManaged public var patient: Patient
}

enum AppointmentAttributes: String {
    case id = "id"
    case patient = "patient"
    case clinic = "clinic"
    case disease = "disease"
    case price = "price"
    case date = "visit_time"
    case state = "state"
    case dentist = "dentist"
    case modifiedAt = "modified_at"
}

//TODO: Tooth
