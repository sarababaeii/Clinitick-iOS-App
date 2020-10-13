//
//  Disease+CoreDataClass.swift
//  Brandent
//
//  Created by Sara Babaei on 9/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Disease)
public class Disease: NSManagedObject {
    
    @available(iOS 13.0, *)
    static func getDisease(title: String, price: Int) -> Disease {
        if let disease = Info.dataController.fetchDisease(title: title) {
            return disease as! Disease
        }
        return Info.dataController.createDisease(title: title, price: price)
    }
}
