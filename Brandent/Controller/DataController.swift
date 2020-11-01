//
//  DataController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/19/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum EntityNames: String {
    case appointment = "Appointment"
    case dentist = "Dentist"
    case patient = "Patient"
    case clinic = "Clinic"
    case speciality = "Speciality"
    case disease = "Disease"
}

class DataController {
    var context: NSManagedObjectContext
    var appointmentEntity: NSEntityDescription
    var dentistEntity: NSEntityDescription
    var patientEntity: NSEntityDescription
    var clinicEntity: NSEntityDescription
    var specialityEntity: NSEntityDescription
    var diseaseEntity: NSEntityDescription
    
    @available(iOS 13.0, *)
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        appointmentEntity = NSEntityDescription.entity(forEntityName: EntityNames.appointment.rawValue, in: context)!
        dentistEntity = NSEntityDescription.entity(forEntityName: EntityNames.dentist.rawValue, in: context)!
        patientEntity = NSEntityDescription.entity(forEntityName: EntityNames.patient.rawValue, in: context)!
        clinicEntity = NSEntityDescription.entity(forEntityName: EntityNames.clinic.rawValue, in: context)!
        specialityEntity = NSEntityDescription.entity(forEntityName: EntityNames.speciality.rawValue, in: context)!
        diseaseEntity = NSEntityDescription.entity(forEntityName: EntityNames.disease.rawValue, in: context)!
    }
    
    func saveContext(){
        do{
            try context.save()
        } catch{
        }
    }
    
    func fetch(object entityName: EntityNames , by attribute: String, value: String) -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        request.predicate = NSPredicate(format: "\(attribute) = %@", value)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            return result.first
        } catch {
            print("Error in fetching patient")
        }
        return nil
    }
    
    func fetchAll(object entityName: EntityNames) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            return result
        } catch{
            print("Error in fetching patient")
        }
        return nil
    }
    
    //MARK: Appointment
    func createAppointment(patient: Patient, disease: Disease, price: Int, visit_time: Date, notes: String?) -> Appointment {
        let appointment = Appointment(entity: appointmentEntity, insertInto: context)
        
        if let price = price as? NSDecimalNumber {
            appointment.price = price
        }
        appointment.visit_time = visit_time
        if let notes = notes {
            appointment.notes = notes
        }
        appointment.state = State.todo.rawValue
        appointment.setID()
        appointment.setPatient(patient: patient)
        appointment.setDisease(disease: disease)
        appointment.setModifiedTime()
        //TODO: set image
        //TODO: set clinic

        saveContext()
        return appointment
    }
    
    func fetchAllAppointments() -> [NSManagedObject]? {
        return fetchAll(object: .appointment)
    }
    
    func fetchAppointments(visitTime: Date) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityNames.appointment.rawValue)
        var predicate: NSPredicate?
        
        let from = visitTime.startOfDate()
        if let to = visitTime.nextDay()?.startOfDate() {
            print("@ from \(from) to \(to)")
            predicate = NSPredicate(format: "visit_time >= %@ AND visit_time <= %@", from as NSDate, to as NSDate)
        }
        
        request.predicate = predicate
        
        let sectionSortDescriptor = NSSortDescriptor(key: "visit_time", ascending: false)
        request.sortDescriptors = [sectionSortDescriptor]
        
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request) as! [NSManagedObject]
            print("***")
            print(result)
            print("***")
            return result
        } catch{
        }
        return nil
    }
    
    //MARK: Patient
    func createPatient(name: String, phone: String, alergies: String?) -> Patient {
        let patient = Patient(entity: patientEntity, insertInto: context)
        
        patient.name = name
        patient.phone = phone
        if let alergies = alergies {
            patient.alergies = alergies
        }
        patient.setID()
        
        saveContext()
        return patient
    }
    
    func fetchPatient(phone: String) -> NSManagedObject? { //English and Persian
        return fetch(object: .patient, by: "phone", value: phone)
    }
    
    func fetchAllPatients() -> [NSManagedObject]? {
        return fetchAll(object: .patient)
    }
    
    //MARK: Disease
    func createDisease(title: String, price: Int) -> Disease {
        let disease = Disease(entity: diseaseEntity, insertInto: context)
        
        disease.title = title
        disease.price = NSDecimalNumber(value: price)
        disease.setID()
        
        //TODO: set for drntist?
        
        saveContext()
        return disease
    }
    
    func fetchDisease(title: String) -> NSManagedObject? {
        return fetch(object: .disease, by: "title", value: title)
    }
    
    func fetchAllDiseases() -> [NSManagedObject]? {
        return fetchAll(object: .disease)
    }
    
    //MARK: Clinic
    func createClinic(title: String, address: String?, color: String) -> Clinic {
        let clinic = Clinic(entity: clinicEntity, insertInto: context)
        
        clinic.title = title
        if let address = address {
            clinic.address = address
        }
        clinic.color = color
        clinic.setID()
        
        saveContext()
        return clinic
    }
    
    func fetchClinic(title: String) -> NSManagedObject? {
        return fetch(object: .clinic, by: "title", value: title)
    }
    
    func fetchAllClinics() -> [NSManagedObject]? {
            return fetchAll(object: .clinic)
    }
    
    func loadData() {
        guard let appointments = fetchAllAppointments() as? [Appointment] else {
            return
        }
        for appointment in appointments {
            print(appointment)
            print(appointment.patient.name as Any)
            print(appointment.patient.phone as Any)
            print("***\n")
        }
    }
}

//    var today: Date{
//        return startOfDay(for: Date())
//    }
//
//    func startOfDay(for date: Date) -> Date {
//        var calendar = Calendar.current
//        calendar.timeZone = TimeZone.current
//        return calendar.startOfDay(for: date) //eg. yyyy-mm-dd 00:00:00
//    }
//
//    func dateCaption(for date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
//        dateFormatter.timeStyle = .none
//        dateFormatter.timeZone = TimeZone.current
//
//        return dateFormatter.string(from: date)
//    }


//insert and replace
