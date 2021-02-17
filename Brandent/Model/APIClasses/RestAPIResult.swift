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
    func isCodeValid() -> Bool {
        if let response = response, response.statusCode == 200 {
            return true
        }
        return false
    }
    
    func authenticate(type: APIRequestType, clinicTitle: String?) -> Int {
        guard let response = response, let data = data else {
            return 500
        }
        if response.statusCode != 200 {
            return response.statusCode
        }
        saveData(data: data, clinicTitle: clinicTitle)
        return 200
    }
    
    private func saveData(data: Data, clinicTitle: String?) {
        guard let dictionary = jsonSerializer.decodeData(data: data) else {
            return
        }
        saveToken(dictionary: dictionary)
        saveDentist(dictionary: dictionary, clinicTitle: clinicTitle)
    }
    
    private func saveToken(dictionary: NSDictionary) {
        guard let token = dictionary["token"] as? String else {
            return
        }
        Info.sharedInstance.token = token
    }
    
    private func saveDentist(dictionary: NSDictionary, clinicTitle: String?) {
        print("Is saving dentist")
        guard let user = dictionary["user"] as? [String: Any],
            let id = user["id"] as? Int,
            let firstName = user["first_name"] as? String,
            let lastName = user["last_name"] as? String,
            let phone = user["phone"] as? String ,
            let speciality = user["speciality"] as? String else {
                print("COULD NOT SAVE DENTIST")
                return
        }
        
        let dentist = Dentist.getDentist(id: NSDecimalNumber(value: id), firstName: firstName, lastName: lastName, phone: phone, speciality: speciality)
        print("DENTIST SAVED SUCCESSFULLY \(dentist)")
        
        Info.sharedInstance.dentistID = id
        saveClinic(clinicTitle: clinicTitle)
        saveProfilePicture(dictionary: user)
        Info.sharedInstance.sync()
    }
    
    private func saveClinic(clinicTitle: String?) {
        if let dentist = Info.sharedInstance.dentist, let clinicTitle = clinicTitle {
            dentist.setClinic(clinicTitle: clinicTitle)
        }
    }
    
    private func saveProfilePicture(dictionary: [String: Any]) {
        if let dentist = Info.sharedInstance.dentist, let photo = getProfilePicture(dictionary: dictionary) {
            dentist.setProfilePicture(photo: photo, fromAPI: true)
        }
    }
    
    private func getProfilePicture(dictionary: [String: Any]) -> Image? {
        guard let fileName = dictionary["image"] as? String else {
            return nil
        }
        let image = Image(name: fileName, urlString: API.profilePictureFile)
        return image
    }
    
    func processProfilePicture() -> Image? {
        if response?.statusCode != 200 {
            print("Error in getting profile picture")
            return nil
        }
        guard let data = data, let result = jsonSerializer.decodeData(data: data), let dictionary = result as? [String: Any] else {
            return nil
        }
        return getProfilePicture(dictionary: dictionary)
    }
    
    //MARK: Sync
    func processOldData(clinics: [Clinic]?, patients: [Patient]?, finances: [Finance]?, tasks: [Task]?, diseases: [Disease]?, appointments: [Appointment]?) {
        guard let response = response, response.statusCode == 200 else {
            return
        }
        Entity.removeDeletedItems(array: clinics)
        Entity.removeDeletedItems(array: patients)
        Entity.removeDeletedItems(array: finances)
        Entity.removeDeletedItems(array: tasks)
        Entity.removeDeletedItems(array: diseases)
        Entity.removeDeletedItems(array: appointments)
    }
    
    func saveNewData() {
        guard let data = data, let result = jsonSerializer.decodeData(data: data) else {
            return
        }
        print(result)
        if let timeString = result["timestamp"] as? String {
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
    
    //MARK: Gallery
    func getImages() -> NSArray? {
        if response?.statusCode != 200 {
            return nil
        }
        guard let data = data, let result = jsonSerializer.decodeData(data: data), let array = getArray(data: result, key: "images") else {
            return nil
        }
        return array
    }
}
 
/*
{\"message\":\"success\",
 \"token\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjo4LCJmaXJzdF9uYW1lIjoi2YHYsdmH2KfYryIsImxhc3RfbmFtZSI6Itio2KfYqNin24zbjCIsInBob25lIjoiMDkxMjYwOTkwMjQiLCJwYXNzd29yZCI6IiQyYSQxMCQyMXgwMmV6YmpVU01aQlhaU0YwY2cuUXJ3Lng2MGZhL3NSYTdTenpmQUNYYnF1UjNkVVRZeSIsImltYWdlIjpudWxsLCJkYXRlX3RpbWUiOiIyMDIxLTAyLTExVDE1OjA2OjI1LjQ0MVoifSwiaWF0IjoxNjEzMDU1OTg1fQ.EL16tF4AvKttEEH04eIpCXkmevV1gl4tX6cpH1sKsVc\",
 \"user\":
     {\"id\":8,
     \"first_name\":\"فرهاد\",
     \"last_name\":\"بابایی\",
     \"phone\":\"09126099024\",
     \"image\":null,
     \"date_time\":\"2021-02-11T15:06:25.441Z\"}}")
 */
