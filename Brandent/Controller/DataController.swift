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
    
    func createAppointment(patient: Patient, disease: Disease, price: Int, visit_time: Date, notes: String?) -> Appointment {
        let appointment = Appointment(entity: appointmentEntity, insertInto: context)
        appointment.patient = patient
        appointment.disease = disease
        if let price = price as? NSDecimalNumber {
            appointment.price = price
        }
        appointment.visit_time = visit_time
        if let notes = notes {
            appointment.notes = notes
        }
        saveContext()
        return appointment
    }
    
    func createPatient(name: String, phone: String, alergies: String?) -> Patient {
        let patient = Patient(entity: patientEntity, insertInto: context)
        patient.name = name
        patient.phone = phone
        if let alergies = alergies {
            patient.alergies = alergies
        }
        saveContext()
        return patient
    }
    
    func createDisease(title: String, price: Int) -> Disease {
        let disease = Disease(entity: diseaseEntity, insertInto: context)
        disease.title = title
        disease.price = price as? NSDecimalNumber
        saveContext()
        return disease
    }
    
    func fetchAppointments() -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityNames.appointment.rawValue)
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request) as! [NSManagedObject]
            return result
        } catch{
            print("Error in fetching patient")
        }
        return nil
    }
    
    func fetchPatient(phone: String) -> NSManagedObject? { //English and Persian
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityNames.patient.rawValue)
        request.predicate = NSPredicate(format: "phone = %@", phone)
//        request.predicate = NSPredicate(format: "createdAt = %@", startOfDay(for: date) as NSDate)
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request) as! [NSManagedObject]
            return result.first
        } catch{
            print("Error in fetching patient")
        }
        return nil
    }
    
    func fetchDisease(title: String) -> NSManagedObject? { //English and Persian
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityNames.disease.rawValue)
        request.predicate = NSPredicate(format: "title = %@", title)
//        request.predicate = NSPredicate(format: "createdAt = %@", startOfDay(for: date) as NSDate)
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request) as! [NSManagedObject]
            return result.first
        } catch{
            print("Error in fetching disease")
        }
        return nil
    }
    
    func loadData() {
        print(fetchAppointments()!)
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
