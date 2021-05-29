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
    static func getClinic(id: UUID?, title: String, address: String?, color: String?, isDeleted: Bool?, modifiedTime: Date?) -> Clinic {
        var clinicColor: String
        if let color = color {
            clinicColor = color
        } else {
            clinicColor = Color.lightGreen.clinicColorDescription
        }
        
        if let id = id, let clinic = getClinicByID(id, isForSync: false) {
            clinic.updateClinic(id: id, title: title, address: address, color: clinicColor, isDeleted: isDeleted, modifiedTime: modifiedTime)
            return clinic
        }
//        if let clinic = getClinicByTitle(title) {
//            return clinic
//        }
        
        return Info.sharedInstance.dataController!.createClinic(id: id, title: title, address: address, color: clinicColor, isDeleted: isDeleted, modifiedTime: modifiedTime)
    }

    static func getClinicByID(_ id: UUID, isForSync: Bool) -> Clinic? {
        if let object = Info.sharedInstance.dataController?.fetchClinic(id: id, isForSync: isForSync), let clinic = object as? Clinic {
            return clinic
        }
        return nil
    }

    static func getClinicByTitle(_ title: String) -> Clinic? {
        if let object = Info.sharedInstance.dataController?.fetchClinic(title: title), let clinic = object as? Clinic {
            return clinic
        }
        return nil
    }

    //MARK: Setting Attributes
    func setAttributes(id: UUID?, title: String, address: String?, color: String, isDeleted: Bool?, modifiedTime: Date?) {
        self.title = title
        self.color = color
        self.address = address

        self.setID(id: id)
        self.setDentist()
        if let isDeleted = isDeleted, let date = modifiedTime {
            self.setDeleteAttributes(to: isDeleted, at: date)
        }
        self.setModifiedTime(at: modifiedTime)
    }
    
    func setDentist() {
        if let dentist = Info.sharedInstance.dentist {
            self.dentist = dentist
        }
    }

    func updateClinic(id: UUID?, title: String, address: String?, color: String, isDeleted: Bool?, modifiedTime: Date?) {
        setAttributes(id: id, title: title, address: address, color: color, isDeleted: isDeleted, modifiedTime: modifiedTime)
        Info.sharedInstance.dataController?.saveContext()
    }
    
    override func delete(to isDeleted: Bool) {
        self.deleteAppointments(to: isDeleted)
        self.deleteTasks(to: isDeleted)
        super.delete(to: isDeleted)
    }
    
    private func deleteAppointments(to isDeleted: Bool) {
        guard let appointments = self.appointments else {
            return
        }
        for appointment in appointments {
            if let appointment = appointment as? Appointment {
                appointment.delete(to: isDeleted)
            }
        }
    }
    
    private func deleteTasks(to isDeleted: Bool) {
        guard let tasks = self.tasks else {
            return
        }
        for task in tasks {
            if let task = task as? Task {
                task.delete(to: isDeleted)
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

    static func saveClinic(_ clinic: NSDictionary, modifiedTime: Date) -> Bool {
        guard let idString = clinic[APIKey.clinic.id!] as? String,
         let id = UUID.init(uuidString: idString),
         let title = clinic[APIKey.clinic.title!] as? String,
         let color = clinic[APIKey.clinic.color!] as? String,
         let isDeletedInt = clinic[APIKey.clinic.isDeleted!] as? Int,
         let isDeleted = Bool.intToBool(value: isDeletedInt) else {
           return false
        }
        var address: String?
        if let add = clinic[APIKey.clinic.address!] as? String {
            address = add
        }
        let _ = getClinic(id: id, title: title, address: address, color: color, isDeleted: isDeleted, modifiedTime: modifiedTime)
        print("#\(id)")
        return true
    }
}

//"clinic": {
//  "id": "3b155280-1a49-11eb-bd07-7d22de018431",
//  "title": "khooneye madarbozorg",
//  "address": "Tehran iran shahre tehran",
//  "color": "color_1"
//}
