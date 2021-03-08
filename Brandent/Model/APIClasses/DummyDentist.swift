//
//  DummyDentist.swift
//  Brandent
//
//  Created by Sara Babaei on 2/8/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation

class DummyDentist {
    var first_name: String
    var last_name: String
    var phone: String
    var password: String
    var speciality: String
    var clinicTitle: String
    var profilePicture: Image?
    
    init(first_name: String, last_name: String, phone: String, password: String, speciality: String, clinicTitle: String, profilePicture: Image?) {
        self.first_name = first_name
        self.last_name = last_name
        self.phone = phone
        self.password = password
        self.speciality = speciality
        self.clinicTitle = clinicTitle
        self.profilePicture = profilePicture
    }
    
    //MARK: API Functions
    func toDictionary() -> [String: String] {
        let params: [String: String] = [
            APIKey.dentist.phone!: self.phone,
            APIKey.dentist.password!: self.password,
            APIKey.dentist.name! : self.first_name,
            APIKey.dentist.lastName!: self.last_name,
            APIKey.dentist.speciality!: self.speciality]
        return params
    }
}

//{
//  "phone": 9203012037,
//  "password": "DAShnj131nADn",
//  "first_name": "Hutch",
//  "last_name": "The honey bee",
//  "speciality": "جمع کردن عسل"
//}
