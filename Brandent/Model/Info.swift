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
    static var sharedInstance = Info()
    
    @available(iOS 13.0, *)
    static var dataController = DataController()
    var lastViewControllerIndex = 0
    var dentist: Dentist? //TODO: Set
    
    let defaults = UserDefaults.standard
    var token: String? {
        get {
            return defaults.string(forKey: DefaultKey.token.rawValue)
        }
        set {
            defaults.set(newValue, forKey: DefaultKey.token.rawValue)
        }
    }
    var lastUpdate: String? {
        get {
            return defaults.string(forKey: DefaultKey.lastUpdated.rawValue)
        }
        set {
            defaults.set(newValue, forKey: DefaultKey.lastUpdated.rawValue)
        }
    }
    
    func sync() {
        print(lastUpdate)
        if lastUpdate == nil {
            lastUpdate = "1970-10-10 10:10:10"
        }
        guard let time = lastUpdate, let lastUpdate = Date.getDBFormatDate(from: time) else {
            RestAPIManagr.sharedInstance.sync(clinics: nil, patients: nil, finances: nil, diseases: nil, appointments: nil)
            print("Couldn't sync")
            return
        }
        let clinics = Info.dataController.fetchClinicsForSync(lastUpdated: lastUpdate) as? [Clinic]
        let patients = Info.dataController.fetchPatientsForSync(lastUpdated: lastUpdate) as? [Patient]
        let finances = Info.dataController.fetchFinancesForSync(lastUpdated: lastUpdate) as? [Finance]
        let diseases = Info.dataController.fetchDiseasesForSync(lastUpdated: lastUpdate) as? [Disease]
        let appointments = Info.dataController.fetchAppointmentsForSync(lastUpdated: lastUpdate) as? [Appointment]
        RestAPIManagr.sharedInstance.sync(clinics: clinics, patients: patients, finances: finances, diseases: diseases, appointments: appointments)
    }
}

// for dentist, save id to defaults and search it from DB
