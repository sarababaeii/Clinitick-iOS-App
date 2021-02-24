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
public class Clinic: Entity {
    //MARK: Initialization
    static func getClinic(id: UUID?, title: String, address: String?, color: String?) -> Clinic {
        var clinicColor: String
        if let color = color {
            clinicColor = color
        } else {
            clinicColor = Color.lightGreen.clinicColor.toHexString()
        }
        
        if let id = id, let clinic = getClinicByID(id) {
            clinic.updateClinic(id: id, title: title, address: address, color: clinicColor)
            return clinic
        }
        if let clinic = getClinicByTitle(title) {
            return clinic
        }
        
        return DataController.sharedInstance.createClinic(id: id, title: title, address: address, color: clinicColor)
    }

    static func getClinicByID(_ id: UUID) -> Clinic? {
        if let object = DataController.sharedInstance.fetchClinic(id: id), let clinic = object as? Clinic {
            return clinic
        }
        return nil
    }

    static func getClinicByTitle(_ title: String) -> Clinic? {
        if let object = DataController.sharedInstance.fetchClinic(title: title), let clinic = object as? Clinic {
            return clinic
        }
        return nil
    }

    //MARK: Setting Attributes
    func setAttributes(id: UUID?, title: String, address: String?, color: String) {
        self.title = title
        self.color = color
        self.address = address

        self.setID(id: id)
        self.setDentist()
        self.setModifiedTime()
    }
    
    func setDentist() {
        if let dentist = Info.sharedInstance.dentist {
            self.dentist = dentist
        }
    }

    func updateClinic(id: UUID?, title: String, address: String?, color: String) {
        setAttributes(id: id, title: title, address: address, color: color)
        DataController.sharedInstance.saveContext()
    }
    
    override func delete() {
        self.deleteAppointments()
        self.deleteTasks()
        super.delete()
    }
    
    private func deleteAppointments() {
        guard let appointments = self.appointments else {
            return
        }
        for appointment in appointments {
            if let appointment = appointment as? Appointment {
                appointment.delete()
            }
        }
    }
    
    private func deleteTasks() {
        guard let tasks = self.tasks else {
            return
        }
        for task in tasks {
            if let task = task as? Task {
                task.delete()
            }
        }
    }

    //MARK: API Functions
    func toDictionary() -> [String: String] {
        var params: [String: String] = [
            APIKey.clinic.id!: self.id.uuidString,
            APIKey.clinic.title!: self.title,
            APIKey.clinic.color! : self.color,
            APIKey.clinic.isDeleted!: String(self.is_deleted)]
        if let address = self.address {
            params[APIKey.clinic.address!] = address
        }
        return params
    }

    static func toDictionaryArray(clinics: [Clinic]) -> [[String: String]] {
        var params = [[String: String]]()
        for clinic in clinics {
            params.append(clinic.toDictionary())
        }
        return params
    }

    static func saveClinic(_ clinic: NSDictionary) {
        guard let idString = clinic[APIKey.clinic.id!] as? String,
         let id = UUID.init(uuidString: idString),
         let title = clinic[APIKey.clinic.title!] as? String,
         let color = clinic[APIKey.clinic.color!] as? String else {
           return
        }
        var address: String?
        if let add = clinic[APIKey.clinic.address!] as? String {
            address = add
        }
        let _ = getClinic(id: id, title: title, address: address, color: color)
    }
}

//"clinic": {
//  "id": "3b155280-1a49-11eb-bd07-7d22de018431",
//  "title": "khooneye madarbozorg",
//  "address": "Tehran iran shahre tehran",
//  "color": "#abcdef"
//}
