//
//  Disease+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 9/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Disease {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Disease> {
        return NSFetchRequest<Disease>(entityName: "Disease")
    }

    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var title: String?
    @NSManaged public var id: NSDecimalNumber?
    @NSManaged public var dentist: Dentist?
    @NSManaged public var specialities: Speciality?
    @NSManaged public var appointments: Appointment?

}
