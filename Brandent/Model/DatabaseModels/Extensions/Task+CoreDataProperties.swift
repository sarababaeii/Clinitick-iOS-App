//
//  Task+CoreDataProperties.swift
//  Brandent
//
//  Created by Sara Babaei on 12/18/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var state: String
    @NSManaged public var clinic: Clinic?
    @NSManaged public var dentist: Dentist
    @NSManaged public var modified_at: Date
}

enum TaskAttributes: String {
    case id = "id"
    case title = "title"
    case date = "date"
    case state = "state"
    case clinic = "clinic"
    case dentist = "dentist"
    case modifiedAt = "modified_at"
}
