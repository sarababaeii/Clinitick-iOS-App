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
    
    //MARK: Initialization
    static func getTask(id: UUID, title: String, date: Date, state: String, clinicID: String?, isDeleted: Bool, modifiedTime: Date) -> Task { //for sync
        var clinic: Clinic?
        if let clinicID = clinicID, let id = UUID(uuidString: clinicID), let theClinic = Clinic.getClinicByID(id, isForSync: true) {
            clinic = theClinic
        }
        if let task = getTaskByID(id) {
            task.updateTask(id: id, title: title, date: date, state: state, clinic: clinic, isDeleted: isDeleted, modifiedTime: modifiedTime)
            return task
        }
        let task = Info.sharedInstance.dataController!.createTask(id: id, title: title, date: date, state: state, clinic: clinic, isDeleted: isDeleted, modifiedTime: modifiedTime)
        UserNotificationManager.sharedInstance.scheduleNotificationForTask(task: task)
        return task
    }
        
    static func getTask(id: UUID?, title: String, date: Date, state: String, clinicTitle: String?, isDeleted: Bool?, modifiedTime: Date?) -> Task { //for add
        var clinic: Clinic?
        if let clinicTitle = clinicTitle, let theClinic = Clinic.getClinicByTitle(clinicTitle) {
            clinic = theClinic
        }
        if let id = id, let task = getTaskByID(id) {
            task.updateTask(id: id, title: title, date: date, state: state, clinic: clinic, isDeleted: isDeleted, modifiedTime: modifiedTime)
            return task
        }
        let task = Info.sharedInstance.dataController!.createTask(id: nil, title: title, date: date, state: state, clinic: clinic, isDeleted: isDeleted, modifiedTime: modifiedTime)
        UserNotificationManager.sharedInstance.scheduleNotificationForTask(task: task)
        return task
    }
    
    static func getTaskByID(_ id: UUID) -> Task? {
        if let object = Info.sharedInstance.dataController?.fetchTask(id: id), let task = object as? Task {
            return task
        }
        return nil
    }
    
    //MARK: Setting Attributes
    func setAttributes(id: UUID?, title: String, date: Date, state: String, clinic: Clinic?, isDeleted: Bool?, modifiedTime: Date?) {
        self.title = title
        self.date = date
        self.clinic = clinic
        self.state = state
        
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
    
    override func delete(to isDeleted: Bool) {
        super.delete(to: isDeleted)
        UserNotificationManager.sharedInstance.removeNotificationForTask(task: self)
    }
    
    func updateTask(id: UUID?, title: String, date: Date, state: String, clinic: Clinic?, isDeleted: Bool?, modifiedTime: Date?) {
        setAttributes(id: id, title: title, date: date, state: state, clinic: clinic, isDeleted: isDeleted, modifiedTime: modifiedTime)
        Info.sharedInstance.dataController?.saveContext()
        UserNotificationManager.sharedInstance.updateNotificationForTask(task: self)
    }
    
    func updateState(state: TaskState) -> Bool {
        if self.state == state.rawValue {
            self.state = TaskState.todo.rawValue
        } else {
            self.state = state.rawValue
        }
        self.setModifiedTime(at: Date())
        Info.sharedInstance.dataController?.saveContext()
        return self.state == state.rawValue
    }
        
    //MARK: API Functions
    func toDictionary() -> [String: String] {
        var params: [String: String] = [
            APIKey.task.id!: self.id.uuidString,
            APIKey.task.title!: self.title,
            APIKey.task.state!: self.state,
            APIKey.task.date!: self.date.toDBFormatDateAndTimeString(isForSync: false),
            APIKey.task.isDeleted!: String(self.is_deleted)]
        
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
        
    static func saveTask(_ task: NSDictionary, modifiedTime: Date) -> Bool {
        guard let idString = task[APIKey.task.id!] as? String,
         let id = UUID.init(uuidString: idString),
         let title = task[APIKey.task.title!] as? String,
         let state = task[APIKey.task.state!] as? String,
         let dateString = task[APIKey.task.date!] as? String,
         let date = Date.getDBFormatDate(from: dateString, isForSync: false),
         let isDeletedInt = task[APIKey.task.isDeleted!] as? Int,
         let isDeleted = Bool.intToBool(value: isDeletedInt)else {
            return false
        }
        var clinicID: String?
        if let id = task[APIKey.task.clinic!] as? String {
            clinicID = id
        }
        let _ = getTask(id: id, title: title, date: date, state: state, clinicID: clinicID, isDeleted: isDeleted, modifiedTime: modifiedTime)
        print("#\(id)")
        return true
    }
}

//"tasks": [
//  {
//     "id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//     "title": "sine saratan",
//     "state": "done",
//     "task_date": "2020-10-9 10:10:10",
//     "clinic_id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//     "is_deleted": false
//  }
//]
