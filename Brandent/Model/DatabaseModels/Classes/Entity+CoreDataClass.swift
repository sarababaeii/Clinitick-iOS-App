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
    
    static func removeDeletedItems(array: [Entity]?) {
        guard let entities = array else {
            return
        }
        var i = 0
        while i < entities.count {
            if entities[i].is_deleted {
                DataController.sharedInstance.permanentDelete(record: entities[i])
                i -= 1
            }
            i += 1
        }
    }
}
