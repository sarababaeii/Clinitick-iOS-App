//
//  Patient+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 9/30/20.
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
    @NSManaged public var name: Float
    @NSManaged public var phone: Float
    @NSManaged public var id: NSDecimalNumber?
    @NSManaged public var history: Appointment?

}
