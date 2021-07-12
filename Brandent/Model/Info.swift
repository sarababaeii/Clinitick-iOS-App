//
//  Info.swift
//  Brandent
//
//  Created by Sara Babaei on 10/9/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class Info {
    static let sharedInstance = Info()
    
    let problems = ["دیابت", "بیماری کلیوی", "سابقه‌ی تب روماتیسمی", "بیماری قلبی عروقی", "آسم", "صرع", "شیمی‌درمانی/پرتودرمانی", "فشار خون", "هپاتیت", "اعتیاد", "بیماری انعقادی", "آلرژی (حساسیت)", "ایدز", "بارداری", "سرطان"]
    var dataController: DataController?
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
    
    var dentistID: Int? { // could be phone
        get {
            return defaults.integer(forKey: DefaultKey.dentistID.rawValue)
        }
        set {
            defaults.set(newValue, forKey: DefaultKey.dentistID.rawValue)
            setDentist()
        }
    }
    
    func setDentist() {
        print("^^^ Dentist ID is: \(dentistID ?? 0)")
        if let id = dentistID {
            dentist = Info.sharedInstance.dataController?.fetchDentist(id: NSDecimalNumber(value: id)) as? Dentist
        } else {
            dentist = nil
        }
        
//        print(dentist)
//        print("!!!")
    }
    
    //MARK: Sync
    func sync() {
        guard let dentist = dentist, let lastUpdate = Date.getTimeStampFormatDate(from: dentist.last_update, isForSync: true) else {
            RestAPIManagr.sharedInstance.sync(clinics: nil, patients: nil, finances: nil, tasks: nil, appointments: nil)
            print("Couldn't sync")
            return
        }
        let clinics = Info.sharedInstance.dataController?.fetchClinicsForSync(lastUpdated: lastUpdate) as? [Clinic]
        let patients = Info.sharedInstance.dataController?.fetchPatientsForSync(lastUpdated: lastUpdate) as? [Patient]
        let finances = Info.sharedInstance.dataController?.fetchFinancesForSync(lastUpdated: lastUpdate) as? [Finance]
        let tasks = Info.sharedInstance.dataController?.fetchTasksForSync(lastUpdated: lastUpdate) as? [Task]
        let appointments = Info.sharedInstance.dataController?.fetchAppointmentsForSync(lastUpdated: lastUpdate) as? [Appointment]
        RestAPIManagr.sharedInstance.sync(clinics: clinics, patients: patients, finances: finances, tasks: tasks, appointments: appointments)
    }
}
