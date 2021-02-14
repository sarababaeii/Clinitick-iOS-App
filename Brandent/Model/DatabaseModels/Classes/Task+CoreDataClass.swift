//
//  Task+CoreDataClass.swift
//  Brandent
//
//  Created by Sara Babaei on 12/18/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: Entity {
    
    static func getTask(id: UUID, title: String, date: Date, clinicID: String?) -> Task {
        if let task = getTaskByID(id) {
            return task
        }
        var clinic: Clinic?
        if let clinicID = clinicID, let id = UUID(uuidString: clinicID), let theClinic = Clinic.getClinicByID(id) {
            clinic = theClinic
        }
        return DataController.sharedInstance.createTask(id: id, title: title, date: date, clinic: clinic)
    }
        
    static func getTask(title: String, date: Date, clinicTitle: String?) -> Task {
        var clinic: Clinic?
        if let clinicTitle = clinicTitle, let theClinic = Clinic.getClinicByTitle(clinicTitle) {
            clinic = theClinic
        }
        return DataController.sharedInstance.createTask(id: nil, title: title, date: date, clinic: clinic)
    }
    
    static func getTaskByID(_ id: UUID) -> Task? {
        if let object = DataController.sharedInstance.fetchTask(id: id), let task = object as? Task {
            return task
        }
        return nil
    }
    
    func setAttributes(id: UUID?, title: String, date: Date, clinic: Clinic?) {
        self.title = title
        self.date = date
        self.clinic = clinic
        self.state = TaskState.todo.rawValue
        self.setID(id: id)
        self.setDentist()
        self.setModifiedTime()
    }
    
    func setDentist() {
        if let dentist = Info.sharedInstance.dentist {
            self.dentist = dentist
        }
    }
    
    func updateState(state: TaskState) {
        self.state = state.rawValue
        self.setModifiedTime()
        DataController.sharedInstance.saveContext()
    }
        
    //MARK: API Functions
    func toDictionary() -> [String: String] {
        var params: [String: String] = [
            APIKey.task.id!: self.id.uuidString,
            APIKey.task.title!: self.title,
            APIKey.task.date!: self.date.toDBFormatDateAndTimeString(),
            APIKey.task.isDeleted!: String(self.isDeleted)]
        
        if let clinic = self.clinic {
            params[APIKey.task.clinic!] = clinic.id.uuidString
        }
        return params
    }
        
    static func toDictionaryArray(tasks: [Task]) -> [[String: String]] {
        var params = [[String: String]]()
        for task in tasks {
            params.append(task.toDictionary())
        }
        return params
    }
        
    static func saveTask(_ task: NSDictionary) {
        guard let idString = task[APIKey.task.id!] as? String,
         let id = UUID.init(uuidString: idString),
         let title = task[APIKey.task.title!] as? String,
         let dateString = task[APIKey.task.date!] as? String,
         let date = Date.getDBFormatDate(from: dateString) else {
            return
        }
        var clinicID: String?
        if let id = task[APIKey.task.clinic!] as? String {
            clinicID = id
        }
        let _ = getTask(id: id, title: title, date: date, clinicID: clinicID)
    }
}

//"tasks": [
//  {
//    "id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//    "title": "sine saratan",
//    "task_date": "2020-10-9 10:10:10",
//    "clinic_id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//    "is_deleted": false
//  }
//]
