//
//  Clinic+CoreDataClass.swift
//  Brandent
//
//  Created by Sara Babaei on 9/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Clinic)
public class Clinic: NSManagedObject {

    @available(iOS 13.0, *)
    static func getClinic(title: String, address: String?, color: String) -> Clinic {
        if let clinic = Info.dataController.fetchClinic(title: title) {
            return clinic as! Clinic
        }
        return Info.dataController.createClinic(title: title, address: address, color: color)
    }
    
    func setID() {
        let uuid = UUID()
        self.id = uuid
    }
}
