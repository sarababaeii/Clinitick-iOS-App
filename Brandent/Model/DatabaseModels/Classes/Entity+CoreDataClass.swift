//
//  Entity+CoreDataClass.swift
//  Brandent
//
//  Created by Sara Babaei on 2/11/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Entity)
public class Entity: NSManagedObject {

    func setID(id: UUID?) {
        if let id = id {
            self.id = id
        } else {
            let uuid = UUID()
            self.id = uuid
        }
    }
    
    func setModifiedTime() {
        self.modified_at = Date()
    }
    
    func delete() {
        DataController.sharedInstance.temporaryDelete(record: self)
    }
    
    func setDeleteAttributes() {
        self.is_deleted = true
        self.setModifiedTime()
    }
}
