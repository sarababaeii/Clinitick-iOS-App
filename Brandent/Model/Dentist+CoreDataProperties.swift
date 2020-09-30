//
//  Dentist+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 9/30/20.
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
    @NSManaged public var clinics: Clinic?
    @NSManaged public var diseases: Disease?
    @NSManaged public var specialities: Speciality?

}
