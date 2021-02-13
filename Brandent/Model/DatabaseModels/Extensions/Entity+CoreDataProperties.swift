//
//  Entity+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 2/11/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var is_deleted: Bool
    @NSManaged public var modified_at: Date

}

enum EntityAttributes: String {
    case id = "id"
    case isDeleted = "is_deleted"
    case modifiedAt = "modified_at"
}
