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

class DataController {
    static let sharedInstance = DataController()
    
    var context: NSManagedObjectContext
    var appointmentEntity: NSEntityDescription
    var dentistEntity: NSEntityDescription
    var patientEntity: NSEntityDescription
    var clinicEntity: NSEntityDescription
    var financeEntity: NSEntityDescription
    var taskEntity: NSEntityDescription
   
    //MARK: Initialization
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        appointmentEntity = NSEntityDescription.entity(forEntityName: EntityNames.appointment.rawValue, in: context)!
        dentistEntity = NSEntityDescription.entity(forEntityName: EntityNames.dentist.rawValue, in: context)!
        patientEntity = NSEntityDescription.entity(forEntityName: EntityNames.patient.rawValue, in: context)!
        clinicEntity = NSEntityDescription.entity(forEntityName: EntityNames.clinic.rawValue, in: context)!
        financeEntity = NSEntityDescription.entity(forEntityName: EntityNames.finance.rawValue, in: context)!
        taskEntity = NSEntityDescription.entity(forEntityName: EntityNames.task.rawValue, in: context)!
    }
    
    //MARK: Save
    func saveContext(){
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.saveContext()
        }
    }
    
    //MARK: Predicates
    private func joinPredicates(predicates: [NSPredicate]) -> NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    private func finilizePredicate(object entityName: EntityNames, predicate: NSPredicate?, isForSync: Bool) -> NSPredicate? {
        if let idPredicate = addDentistIDToPredicate(object: entityName, predicate: predicate) {
            return addNotDeletedToPredicate(object: entityName, predicate: idPredicate, isForSync: isForSync)
        }
        return nil
    }
    
    private func addDentistIDToPredicate(object entityName: EntityNames, predicate: NSPredicate?) -> NSPredicate? {
        if entityName == .dentist {
            return predicate
        }
        guard let id = Info.sharedInstance.dentistID else {
            return nil
        }
        print("%?% \(id)")
        let idPredicate = NSPredicate(format: "dentist.id = %d", id)
        if let predicate = predicate {
            return joinPredicates(predicates: [idPredicate, predicate])
        }
        return idPredicate
    }
    
    private func addNotDeletedToPredicate(object entityName: EntityNames, predicate: NSPredicate?, isForSync: Bool) -> NSPredicate? {
        if entityName == .dentist || isForSync {
            return predicate
        }
        let deletedAttribute = EntityAttributes.isDeleted.rawValue
        let deletedPredicate = NSPredicate(format: "\(deletedAttribute) = %d", false)
        if let predicate = predicate {
            return joinPredicates(predicates: [deletedPredicate, predicate])
        }
        return deletedPredicate
    }
    
    private func predicateForTimeInterval(dateAttribute: String, start: Date?, end: Date?) -> NSPredicate? {
        guard let from = start, let to = end else {
            return nil
        }
        return NSPredicate(format: "\(dateAttribute) >= %@ AND \(dateAttribute) < %@", from as NSDate, to as NSDate)
    }
    
    //MARK: Fetch
    private func fetchRequest(object entityName: EntityNames, predicate: NSPredicate?, sortBy key: String?, isForSync: Bool) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        if let predicate = finilizePredicate(object: entityName, predicate: predicate, isForSync: isForSync) {
            request.predicate = predicate
        }
        if let key = key { //Sorting
            let sectionSortDescriptor = NSSortDescriptor(key: key, ascending: true)
            request.sortDescriptors = [sectionSortDescriptor]
        }
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            return result
        } catch {
            print("Error in fetching \(entityName.rawValue)")
            return nil
        }
    }
    
    private func fetchAll(object entityName: EntityNames, sortBy key: String?) -> [NSManagedObject]? {
        return fetchRequest(object: entityName, predicate: nil, sortBy: key, isForSync: false)
    }
    
    private func fetchObject(object entityName: EntityNames, by attribute: String, value: String) -> NSManagedObject? {
        let predicate = NSPredicate(format: "\(attribute) = %@", value)
        return fetchRequest(object: entityName, predicate: predicate, sortBy: nil, isForSync: false)?.first
    }
    
    private func fetchObject(object entityName: EntityNames, idAttribute: String, id: UUID, isForSync: Bool) -> NSManagedObject? {
        let predicate = NSPredicate(format: "\(idAttribute) = %@", id as CVarArg)
        return fetchRequest(object: entityName, predicate: predicate, sortBy: nil, isForSync: isForSync)?.first
    }
    
    private func fetchForSync(entityName: EntityNames, modifiedAttribute: String, lastUpdated date: Date) -> [NSManagedObject]? {
        let predicate = NSPredicate(format: "\(modifiedAttribute) > %@", date as NSDate)
        return fetchRequest(object: entityName, predicate: predicate, sortBy: nil, isForSync: true)
    }
    
    private func fetchObjectsInTimeInterval(object: EntityNames, dateAttribute: String, start: Date?, end: Date?) -> [NSManagedObject]? {
        if let predicate = predicateForTimeInterval(dateAttribute: dateAttribute, start: start, end: end) {
            return fetchRequest(object: object, predicate: predicate, sortBy: dateAttribute, isForSync: false)
        }
        return nil
    }
    
    //MARK: Delete
    func temporaryDelete(record: Entity) {
        record.setDeleteAttributes()
        saveContext()
    }
    
    func permanentDelete(record: NSManagedObject) {
        context.delete(record)
        saveContext()
    }
    
    //MARK: Appointment
    func createAppointment(id: UUID?, patient: Patient, disease: String, price: Int?, visit_time: Date?, clinic: Clinic, state: String, isDeleted: Bool?, modifiedTime: Date?) -> Appointment {
        let appointment = Appointment(entity: appointmentEntity, insertInto: context)
        appointment.setAttributes(id: id, patient: patient, disease: disease, price: price, visit_time: visit_time, clinic: clinic, state: state, isDeleted: isDeleted, modifiedTime: modifiedTime)
        saveContext()
        return appointment
    }

    func fetchAppointment(id: UUID) -> NSManagedObject? {
        return fetchObject(object: .appointment, idAttribute: AppointmentAttributes.id.rawValue, id: id, isForSync: false)
    }
    
    func fetchAppointmentsForSync(lastUpdated date: Date) -> [NSManagedObject]? {
        return fetchForSync(entityName: .appointment, modifiedAttribute: AppointmentAttributes.modifiedAt.rawValue, lastUpdated: date)
    }
    
    func fetchAppointmentsInMonth(in date: Date) -> [NSManagedObject]? {
        let dateAttribute = AppointmentAttributes.date.rawValue
        guard let datePredicate = predicateForTimeInterval(dateAttribute: dateAttribute, start: date.startOfMonth(), end: date.endOfMonth()) else {
            return nil
        }
        let stateAttribute = AppointmentAttributes.state.rawValue
        let statePredicate = NSPredicate(format: "\(stateAttribute) == %@", TaskState.done.rawValue)
        let predicate = joinPredicates(predicates: [datePredicate, statePredicate])
        return fetchRequest(object: .appointment, predicate: predicate, sortBy: dateAttribute, isForSync: false)
//        return fetchObjectsInTimeInterval(object: .appointment, dateAttribute: AppointmentAttributes.date.rawValue, start: date.startOfMonth(), end: date.endOfMonth())
    }
    
    func fetchAppointmentsInDay(from date: Date) -> [NSManagedObject]? {
        print(date)
        return fetchObjectsInTimeInterval(object: .appointment, dateAttribute: AppointmentAttributes.date.rawValue, start: date, end: date.nextDay()?.startOfDate())
    }
    
    func fetchTodayAppointments(in clinic: Clinic?) -> [NSManagedObject]? {
        guard let datePredicate = predicateForTimeInterval(dateAttribute: AppointmentAttributes.date.rawValue, start: Date().startOfDate(), end: Date().nextDay()) else {
            return nil
        }
        let clinicAttribute = AppointmentAttributes.clinic.rawValue
        let titleAttribute = ClinicAttributes.title.rawValue
        let clinicPredicate = NSPredicate(format: "\(clinicAttribute).\(titleAttribute) == %@", clinic?.title ?? NSNull())
        return fetchRequest(object: .appointment, predicate: joinPredicates(predicates: [datePredicate, clinicPredicate]), sortBy: nil, isForSync: false)
    }
    
    func getTodayTasks() -> [TodayTasks]? {
        var todayTasks = [TodayTasks]()
        if let clinics = fetchAllClinics() as? [Clinic], clinics.count > 0 {
            for clinic in clinics {
                if let appointments = fetchTodayAppointments(in: clinic) as? [Appointment], appointments.count > 0 {
                    todayTasks.append(TodayTasks(number: appointments.count, clinic: clinic))
                }
            }
        }
        if let appointments = fetchTodayAppointments(in: nil) as? [Appointment], appointments.count > 0 {
            todayTasks.append(TodayTasks(number: appointments.count, clinic: nil))
        }
        return todayTasks
    }
    
    func getNextAppointment() -> Appointment? {
        if let todayAppointments = fetchAppointmentsInDay(from: Date()) {
            return todayAppointments.first as? Appointment
        }
        return nil
    }
    
    //MARK: Task
    func createTask(id: UUID?, title: String, date: Date, clinic: Clinic?, isDeleted: Bool?, modifiedTime: Date?) -> Task {
        let task = Task(entity: taskEntity, insertInto: context)
        task.setAttributes(id: id, title: title, date: date, clinic: clinic, isDeleted: isDeleted, modifiedTime: modifiedTime)
        saveContext()
        return task
    }
    
    func fetchTask(id: UUID) -> NSManagedObject? {
        return fetchObject(object: .task, idAttribute: TaskAttributes.id.rawValue, id: id, isForSync: false)
    }
    
    func fetchTasksForSync(lastUpdated date: Date) -> [NSManagedObject]? {
        return fetchForSync(entityName: .task, modifiedAttribute: TaskAttributes.modifiedAt.rawValue, lastUpdated: date)
    }
    
    func fetchTasksInDay(in date: Date) -> [NSManagedObject]? {
        return fetchObjectsInTimeInterval(object: .task, dateAttribute: TaskAttributes.date.rawValue, start: date.startOfDate(), end: date.nextDay()?.startOfDate())
    }
    
    func fetchTasksAndAppointments(in date: Date) -> [NSManagedObject]? {
        let appointments = fetchAppointmentsInDay(from: date.startOfDate()) as? [Appointment]
        let tasks = fetchTasksInDay(in: date) as? [Task]
        return Appointment.sort(appointments: appointments, others: tasks)
    }
    
    //MARK: Finance
    func createFinance(id: UUID?, title: String, amount: Int, isCost: Bool, date: Date, isDeleted: Bool?, modifiedTime: Date?) -> Finance {
        let finance = Finance(entity: financeEntity, insertInto: context)
        finance.setAttributes(id: id, title: title, amount: amount, isCost: isCost, date: date, isDeleted: isDeleted, modifiedTime: modifiedTime)
        saveContext()
        return finance
    }
    
    func fetchFinance(id: UUID) -> NSManagedObject? {
        return fetchObject(object: .finance, idAttribute: FinanceAttributes.id.rawValue, id: id, isForSync: false)
    }
    
    func fetchFinancesForSync(lastUpdated date: Date) -> [NSManagedObject]? {
        return fetchForSync(entityName: .finance, modifiedAttribute: FinanceAttributes.modifiedAt.rawValue, lastUpdated: date)
    }
    
    func financeFetchRequest(in month: Date, isCost: Bool?) -> [NSManagedObject]? {
        let dateAttribute = FinanceAttributes.date.rawValue
        guard let datePredicate = predicateForTimeInterval(dateAttribute: dateAttribute, start: month.startOfMonth(), end: month.endOfMonth()) else {
            return nil
        }
        var predicate = datePredicate
        if let isCost = isCost {
            let isCostAttribute = FinanceAttributes.isCost.rawValue
            let isCostPredicate = NSPredicate(format: "\(isCostAttribute) == %d", isCost)
            predicate = joinPredicates(predicates: [predicate, isCostPredicate])
        }
        return fetchRequest(object: .finance, predicate: predicate, sortBy: dateAttribute, isForSync: false)
    }
    
    func fetchFinanceExternalIncomes(in month: Date) -> [NSManagedObject]? {
        return financeFetchRequest(in: month, isCost: false)
    }
    
    func fetchFinanceCosts(in month: Date) -> [NSManagedObject]? {
        return financeFetchRequest(in: month, isCost: true)
    }
    
    func fetchFinances(in month: Date) -> [NSManagedObject]? {
        return financeFetchRequest(in: month, isCost: nil)
    }
    
    func fetchFinancesAndAppointments(in month: Date) -> [NSManagedObject]? {
        let appointments = fetchAppointmentsInMonth(in: month) as? [Appointment]
        let finances = fetchFinances(in: month) as? [Finance]
        return Appointment.sort(appointments: appointments, others: finances)
    }
    
    //MARK: Patient
    func createPatient(id: UUID?, name: String, phone: String, alergies: String?, isDeleted: Bool?, modifiedTime: Date?) -> Patient {
        let patient = Patient(entity: patientEntity, insertInto: context)
        patient.setAttributes(id: id, name: name, phone: phone, alergies: alergies, isDeleted: isDeleted, modifiedTime: modifiedTime)
        saveContext()
        return patient
    }
    
    func fetchPatient(phone: String) -> NSManagedObject? {
        let phoneAttribute = PatientAttributes.phone.rawValue
        let predicate = NSPredicate(format: "\(phoneAttribute) = %@", phone)
        return fetchRequest(object: .patient, predicate: predicate, sortBy: nil, isForSync: false)?.first
    }
    
    func fetchPatient(id: UUID, isForSync: Bool) -> NSManagedObject? {
        return fetchObject(object: .patient, idAttribute: PatientAttributes.id.rawValue, id: id, isForSync: isForSync)
    }
    
    func fetchAllPatients() -> [NSManagedObject]? {
        return fetchAll(object: .patient, sortBy: PatientAttributes.name.rawValue)
    }
    
    func fetchPatientsForSync(lastUpdated date: Date) -> [NSManagedObject]? {
        return fetchForSync(entityName: .patient, modifiedAttribute: PatientAttributes.modifiedAt.rawValue, lastUpdated: date)
    }
    
    //MARK: Clinic
    func createClinic(id: UUID?, title: String, address: String?, color: String, isDeleted: Bool?, modifiedTime: Date?) -> Clinic {
        let clinic = Clinic(entity: clinicEntity, insertInto: context)
        clinic.setAttributes(id: id, title: title, address: address, color: color, isDeleted: isDeleted, modifiedTime: modifiedTime)
        saveContext()
        return clinic
    }
    
    func fetchClinic(title: String) -> NSManagedObject? {
        return fetchObject(object: .clinic, by: ClinicAttributes.title.rawValue, value: title)
    }
    
    func fetchClinic(id: UUID, isForSync: Bool) -> NSManagedObject? {
        return fetchObject(object: .clinic, idAttribute: ClinicAttributes.id.rawValue, id: id, isForSync: isForSync)
    }
    
    func fetchAllClinics() -> [NSManagedObject]? {
        return fetchAll(object: .clinic, sortBy: ClinicAttributes.title.rawValue)
    }
    
    func fetchClinicsForSync(lastUpdated date: Date) -> [NSManagedObject]? {
        return fetchForSync(entityName: .clinic, modifiedAttribute: ClinicAttributes.modifiedAt.rawValue, lastUpdated: date)
    }
    
    //MARK: Dentist
    func createDentist(id: NSDecimalNumber, firstName: String, lastName: String, phone: String, speciality: String) -> Dentist {
        let dentist = Dentist(entity: dentistEntity, insertInto: context)
        dentist.setAttributes(id: id, firstName: firstName, lastName: lastName, phone: phone, speciality: speciality)
        saveContext()
        return dentist
    }
    
    func setDentistPhoto(dentist: Dentist, photo: Image) {
        dentist.photo = photo.data
        saveContext()
    }
    
    func setDentistClinic(dentist: Dentist, clinic: Clinic) {
        dentist.addToClinics(clinic)
        saveContext()
    }
    
    func fetchDentist(id: NSDecimalNumber) -> NSManagedObject? {
        let predicate = NSPredicate(format: "\(DentistAttributes.id.rawValue) == %@", id)
        return fetchRequest(object: .dentist, predicate: predicate, sortBy: nil, isForSync: false)?.first
    }
    
    func fetchDentist(phone: String) -> NSManagedObject? {
        return fetchObject(object: .dentist, by: DentistAttributes.phone.rawValue, value: phone)
    }
}

//insert and replace
