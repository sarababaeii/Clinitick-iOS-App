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
    
    static let addAppointmentURL = URL(string: API.addAppointment)!
    static let addImageURL = URL(string: API.images)!
    static let addClinicURL = URL(string: API.addClinic)!
    static let addFinanceURL = URL(string: API.finance)!
    static let syncURL = URL(string: API.sync)!
}
