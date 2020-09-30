//
//  Speciality+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 9/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Speciality {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Speciality> {
        return NSFetchRequest<Speciality>(entityName: "Speciality")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: NSDecimalNumber?
    @NSManaged public var dentist: Dentist?
    @NSManaged public var diseases: Disease?

}
