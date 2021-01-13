//
//  APIAddress.swift
//  Brandent
//
//  Created by Sara Babaei on 11/20/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

struct API {
    private static let server = "http://185.235.40.77:7000/"
    private static let base = API.server + "api/"
    private static let add = "/add"
    
    private static let sync = API.base + "sync"
    
    private static let appointment = API.base + "appointments"
    private static let addAppointment = API.appointment + API.add
    
    private static let patient = API.base + "patients"
    public static let images = API.patient + "/images"
    public static let image = API.server + "public/uploads/"
    
    private static let clinic = API.base + "clinics"
    private static let addClinic = API.clinic + API.add
    
    private static let finance = API.base + "finances"
    
    private static let authentication = API.base + "auth/"
    private static let login = API.authentication + "login"
    private static let signUp = API.authentication + "register"
    private static let sendPhone = API.signUp + "/phone"
    private static let sendCode = API.signUp + "/code"
    
    static let addAppointmentURL = URL(string: API.addAppointment)!
    static let addImageURL = URL(string: API.images)!
    static let addClinicURL = URL(string: API.addClinic)!
    static let addFinanceURL = URL(string: API.finance)!
    static let syncURL = URL(string: API.sync)!
    static let loginURL = URL(string: API.login)!
    static let signUpURL = URL(string: API.signUp)!
    static let sendPhoneURL = URL(string: API.sendPhone)!
    static let sendCodeURL = URL(string: API.sendCode)!
}
