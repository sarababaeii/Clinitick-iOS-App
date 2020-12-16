//
//  RestAPIResult.swift
//  Brandent
//
//  Created by Sara Babaei on 12/16/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

class RestAPIResult {
    let jsonSerializer = JSONSerializer()
    
    var data: Data?
    var response: HTTPURLResponse?
    
    init(data: Data?, response: HTTPURLResponse?) {
        self.data = data
        self.response = response
    }
    
    //MARK: Authentication
    func authenticate(type: APIRequestType) {
        guard let data = data else {
            return
        }
        if type == .login {
            saveDentist(data: data)
        }
        saveToken(data: data)
    }
    
    private func saveDentist(data: Data) {
        print("Is saving dentist")
        //TODO: Save dentist information in local DB
    }
    
    private func saveToken(data: Data) {
        guard let dictionary = jsonSerializer.decodeData(data: data), let token = dictionary["token"] as? String else {
            return
        }
        Info.sharedInstance.token = token
    }
    
    func isCodeValid() -> Bool {
        if let response = response, response.statusCode == 200 {
            return true
        }
        return false
    }
    
    //MARK: Authentication
    func saveNewData() {
        guard let data = data, let result = jsonSerializer.decodeData(data: data) else {
            return
        }
        print(result)
        if let timeString = result["timestamp"] as? String { //TODO: Test
            Info.sharedInstance.lastUpdate = timeString
        }
        let keys: [APIKey] = [.clinic, .patient, .finance, .disease, .appointment]
        for key in keys {
            if let array = getArray(data: result, key: key.sync!) {
                saveArray(array: array, key: key)
            }
        }
    }
    
    private func getArray(data: NSDictionary, key: String) -> NSArray? {
        return data[key] as? NSArray
    }
    
    private func saveArray(array: NSArray, key: APIKey) {
        for item in array {
            if let dictionary = item as? NSDictionary {
                switch key {
                case .clinic:
                    Clinic.saveClinic(dictionary)
                case .patient:
                    Patient.savePatient(dictionary)
                case .finance:
                    Finance.saveFinance(dictionary)
                case .disease:
                    Disease.saveDisease(dictionary)
                case .appointment:
                    Appointment.saveAppointment(dictionary)
                default:
                    return
                }
            }
        }
    }
}
