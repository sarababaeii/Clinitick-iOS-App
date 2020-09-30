//
//  Clinic+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 9/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Clinic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Clinic> {
        return NSFetchRequest<Clinic>(entityName: "Clinic")
    }

    @NSManaged public var id: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var appointments: Appointment?
    @NSManaged public var dentist: Dentist?

}
