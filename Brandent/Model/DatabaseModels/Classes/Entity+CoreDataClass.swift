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
    
    func setModifiedTime(at date: Date?) {
        self.modified_at = date ?? Date()
    }
    
    func delete(to isDeleted: Bool) {
        setDeleteAttributes(to: isDeleted)
//        Info.sharedInstance.dataController?.temporaryDelete(record: self)
    }
    
    func setDeleteAttributes(to isDeleted: Bool) {
        self.is_deleted = isDeleted
        self.setModifiedTime(at: nil)
    }
    
    func setDeleteAttributes(to isDeleted: Bool, at date: Date) {
        self.is_deleted = isDeleted
        self.setModifiedTime(at: date)
    }
    
    static func removeDeletedItems(array: [Entity]?) {
        guard let entities = array else {
            return
        }
        var i = 0
        while i < entities.count {
            if entities[i].is_deleted {
                Info.sharedInstance.dataController?.permanentDelete(record: entities[i])
                i -= 1
            }
            i += 1
        }
    }
}
