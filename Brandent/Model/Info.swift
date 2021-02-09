//
//  Info.swift
//  Brandent
//
//  Created by Sara Babaei on 10/9/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class Info {
    static let sharedInstance = Info()
    
    let defaults = UserDefaults.standard
    var lastViewControllerIndex: Int?
    var isForReturn = false
    
    //MARK: User Data
    var dentist: Dentist?
    
    var token: String? {
        get {
            return defaults.string(forKey: DefaultKey.token.rawValue)
        }
        set {
            defaults.set(newValue, forKey: DefaultKey.token.rawValue)
        }
    }
    
    var dentistID: String? { // could be phone
        get {
            return defaults.string(forKey: DefaultKey.dentistID.rawValue)
        }
        set {
            defaults.set(newValue, forKey: DefaultKey.dentistID.rawValue)
            setDentist()
        }
    }
    
    func setDentist() {
        print("^^^ Dentist ID is: \(dentistID ?? "NIL")")
        if let idString = dentistID, let id = Int(idString) {
            dentist = DataController.sharedInstance.fetchDentist(id: NSDecimalNumber(value: id)) as? Dentist
        } else {
            dentist = nil
        }
    }
    
    //MARK: Sync
    var lastUpdate: String? {
        get {
            return defaults.string(forKey: DefaultKey.lastUpdated.rawValue)
        }
        set {
            defaults.set(newValue, forKey: DefaultKey.lastUpdated.rawValue)
        }
    }
    
    func sync() {
        print("Last Updated in: \(lastUpdate ?? "NIL")")
        
        if lastUpdate == nil {
            lastUpdate = "1970-10-10 10:10:10"
        }
        guard let time = lastUpdate, let lastUpdate = Date.getDBFormatDate(from: time) else {
            RestAPIManagr.sharedInstance.sync(clinics: nil, patients: nil, finances: nil, tasks: nil, diseases: nil, appointments: nil)
            print("Couldn't sync")
            return
        }
        let clinics = DataController.sharedInstance.fetchClinicsForSync(lastUpdated: lastUpdate) as? [Clinic]
        let patients = DataController.sharedInstance.fetchPatientsForSync(lastUpdated: lastUpdate) as? [Patient]
        let finances = DataController.sharedInstance.fetchFinancesForSync(lastUpdated: lastUpdate) as? [Finance]
        let tasks = DataController.sharedInstance.fetchTasksForSync(lastUpdated: lastUpdate) as? [Task]
        let diseases = DataController.sharedInstance.fetchDiseasesForSync(lastUpdated: lastUpdate) as? [Disease]
        let appointments = DataController.sharedInstance.fetchAppointmentsForSync(lastUpdated: lastUpdate) as? [Appointment]
        RestAPIManagr.sharedInstance.sync(clinics: clinics, patients: patients, finances: finances, tasks: tasks, diseases: diseases, appointments: appointments)
    }
}
