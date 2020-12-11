//
//  APIAddress.swift
//  Brandent
//
//  Created by Sara Babaei on 11/20/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

struct API {
    private static let base = "http://185.235.40.77:7000/api/"
    private static let sync = API.base + "sync"
    private static let appointment = API.base + "appointments"
    private static let add = "/add"
    private static let addAppointment = API.appointment + API.add
    private static let images = API.addAppointment + "/images"
    private static let clinic = API.base + "clinics"
    private static let addClinic = API.clinic + API.add
    private static let finance = API.base + "finances"
    private static let authentication = API.base + "auth"
    private static let login = API.authentication + "/login"
    private static let signUp = API.authentication + "/register"
    
    static let addAppointmentURL = URL(string: API.addAppointment)!
    static let addImageURL = URL(string: API.images)!
    static let addClinicURL = URL(string: API.addClinic)!
    static let addFinanceURL = URL(string: API.finance)!
    static let syncURL = URL(string: API.sync)!
    static let loginURL = URL(string: API.login)!
    static let signUpURL = URL(string: API.signUp)!
}
