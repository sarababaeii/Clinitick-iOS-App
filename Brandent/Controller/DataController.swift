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
    case finance = "Finance"
}

class DataController {
    var context: NSManagedObjectContext
    var appointmentEntity: NSEntityDescription
    var dentistEntity: NSEntityDescription
    var patientEntity: NSEntityDescription
    var clinicEntity: NSEntityDescription
    var specialityEntity: NSEntityDescription
    var diseaseEntity: NSEntityDescription
    var financeEntity: NSEntityDescription
    
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
        financeEntity = NSEntityDescription.entity(forEntityName: EntityNames.finance.rawValue, in: context)!
    }
    
    func saveContext(){
        do{
            try context.save()
        } catch{
        }
    }
    
    func fetchRequest(object entityName: EntityNames, predicate: NSPredicate?, sortBy key: String?) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        if let predicate = predicate {
            request.predicate = predicate
        }
        if let key = key { //Sorting
            let sectionSortDescriptor = NSSortDescriptor(key: key, ascending: false)
            request.sortDescriptors = [sectionSortDescriptor]
        }
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            return result
        } catch {
            print("Error in fetching \(entityName.rawValue)")
        }
        return nil
    }
    
    func fetchAll(object entityName: EntityNames, sortBy key: String?) -> [NSManagedObject]? {
        return fetchRequest(object: entityName, predicate: nil, sortBy: key)
    }
    
    func fetch(object entityName: EntityNames, by attribute: String, value: String) -> NSManagedObject? {
        let predicate = NSPredicate(format: "\(attribute) = %@", value)
        return fetchRequest(object: entityName, predicate: predicate, sortBy: nil)?.first
    }
    
    //MARK: Appointment
    func createAppointment(patient: Patient, disease: Disease, price: Int, visit_time: Date, clinic: Clinic?, alergies: String?, notes: String?) -> Appointment {
        let appointment = Appointment(entity: appointmentEntity, insertInto: context)
        
        if let price = price as? NSDecimalNumber {
            appointment.price = price
        }
        appointment.visit_time = visit_time
        appointment.clinic = clinic
        appointment.alergies = alergies
        appointment.notes = notes

        appointment.state = State.todo.rawValue
        appointment.setID()
        appointment.setPatient(patient: patient)
        appointment.setDisease(disease: disease)
        appointment.setModifiedTime()
        //TODO: set image

        saveContext()
        return appointment
    }
    
    func fetchAllAppointments() -> [NSManagedObject]? {
        return fetchAll(object: .appointment, sortBy: nil)
    }
    
    func fetchAppointmentsInDay(in date: Date) -> [NSManagedObject]? {
        guard let to = date.nextDay()?.startOfDate() else {
            return nil
        }
        let dateAttribute = AppointmentAttributes.date.rawValue
        let predicate = NSPredicate(format: "\(dateAttribute) >= %@ AND \(dateAttribute) <= %@", date.startOfDate() as NSDate, to as NSDate)
        return fetchRequest(object: .appointment, predicate: predicate, sortBy: dateAttribute)
    }
    
    func fetchAppointmentsInMonth(in date: Date) -> [NSManagedObject]? {
        let dateAttribute = AppointmentAttributes.date.rawValue
        let predicate = NSPredicate(format: "\(dateAttribute) >= %@ AND \(dateAttribute) <= %@", date.startOfMonth() as NSDate, date.endOfMonth() as NSDate)
        return fetchRequest(object: .appointment, predicate: predicate, sortBy: dateAttribute)
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
        patient.setModifiedTime()
        
        saveContext()
        return patient
    }
    
    func fetchPatient(phone: String) -> NSManagedObject? { //English and Persian
        return fetch(object: .patient, by: PatientAttributes.phone.rawValue, value: phone)
    }
    
    func fetchAllPatients() -> [NSManagedObject]? {
        return fetchAll(object: .patient, sortBy: PatientAttributes.name.rawValue)
    }
    
    //MARK: Disease
    func createDisease(title: String, price: Int) -> Disease {
        let disease = Disease(entity: diseaseEntity, insertInto: context)
        
        disease.title = title
        disease.price = NSDecimalNumber(value: price)
        disease.setID()
        disease.setModifiedTime()
        //TODO: set for dentist?
        
        saveContext()
        return disease
    }
    
    func fetchDisease(title: String) -> NSManagedObject? {
        return fetch(object: .disease, by: DiseaseAttributes.title.rawValue, value: title)
    }
    
    func fetchAllDiseases() -> [NSManagedObject]? {
        return fetchAll(object: .disease, sortBy: DiseaseAttributes.title.rawValue)
    }
    
    //MARK: Clinic
    func createClinic(title: String, address: String?, color: String?) -> Clinic {
        let clinic = Clinic(entity: clinicEntity, insertInto: context)
        
        clinic.title = title
        if let address = address {
            clinic.address = address
        }
        if let color = color {
            clinic.color = color
        } else {
            clinic.color = Color.lightGreen.clinicColor.toHexString()
        }
        
        clinic.setID()
        clinic.setModifiedTime()
        
        saveContext()
        return clinic
    }
    
    func fetchClinic(title: String) -> NSManagedObject? {
        return fetch(object: .clinic, by: ClinicAttributes.title.rawValue, value: title)
    }
    
    func fetchAllClinics() -> [NSManagedObject]? {
        return fetchAll(object: .clinic, sortBy: ClinicAttributes.title.rawValue)
    }
    
    //MARK: Finance
    @available(iOS 13.0, *)
    func createFinance(title: String, amount: Int, isCost: Bool, date: Date) -> Finance {
        let finance = Finance(entity: financeEntity, insertInto: context)
        
        finance.title = title
        finance.amount = NSDecimalNumber(value: amount)
        finance.is_cost = isCost
        finance.date = date
        finance.setID()
        finance.setModifiedTime()
        
        saveContext()
        return finance
    }
    
    func fetchAllFinances(in month: Date) -> [NSManagedObject]? {
        return nil
    } //TODO
    
    func fetchSpecificFinance(in month: Date, isCost: Bool) -> [NSManagedObject]? {
        let dateAttribute = FinanceAttributes.date.rawValue
        let isCostAttribute = FinanceAttributes.isCost.rawValue
        let predicate = NSPredicate(format: "\(dateAttribute) >= %@ AND \(dateAttribute) <= %@ AND \(isCostAttribute) = %d", month.startOfMonth() as NSDate, month.endOfMonth() as NSDate, isCost)
        return fetchRequest(object: .finance, predicate: predicate, sortBy: dateAttribute)
    }
    
    func fetchFinanceExternalIncomes(in month: Date) -> [NSManagedObject]? {
        return fetchSpecificFinance(in: month, isCost: false)
    }
    
    func fetchFinanceCosts(in month: Date) -> [NSManagedObject]? {
        return fetchSpecificFinance(in: month, isCost: true)
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

//TODO: fetch both appointments and finances
//TODO: iOS availability
