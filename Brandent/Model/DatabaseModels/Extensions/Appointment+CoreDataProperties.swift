//
//  Appointment+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 10/1/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Appointment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Appointment> {
        return NSFetchRequest<Appointment>(entityName: "Appointment")
    }

//    @NSManaged public var isDeleted: Bool
    @NSManaged public var id: UUID
    @NSManaged public var images: Data?
    @NSManaged public var modifiedAt: Date
    @NSManaged public var notes: String?
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var state: String
    @NSManaged public var visit_time: Date
    @NSManaged public var clinic: Clinic?
    @NSManaged public var disease: Disease?
    @NSManaged public var patient: Patient

}
