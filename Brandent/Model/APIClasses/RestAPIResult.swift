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
            let idString = user["id"] as? String,
            let id = Int(idString),
            let firstName = user["first_name"] as? String,
            let lastName = user["last_name"] as? String,
            let phone = user["phone"] as? String,
            let speciality = user["speciality"] as? String else {
                print("COULD NOT SAVE DENTIST")
                return
        }
        
        let dentist = Dentist.getDentist(id: NSDecimalNumber(value: id), firstName: firstName, lastName: lastName, phone: phone, speciality: speciality)
        print("DENTIST SAVED SUCCESSFULLY \(dentist)")
        
        Info.sharedInstance.dentistID = idString
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
 \"token\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjo1LCJmaXJzdF9uYW1lIjoi2LPYp9ix2KciLCJsYXN0X25hbWUiOiLYqNin2KjYp9uM24wiLCJwaG9uZSI6IjA5MTkwMzA3NjY4IiwicGFzc3dvcmQiOiIkMmEkMTAkNFhxdTJmQWU4LlFtekxCLzNkalNBLmlRSHguT09UWXRsOVlTQ3hyZzJ0eS5pSVVwLlR3Um0iLCJpbWFnZSI6bnVsbCwiZGF0ZV90aW1lIjoiMjAyMS0wMi0wOVQxMTo0Mjo1NS41MDJaIn0sImlhdCI6MTYxMjg3MDk3NX0.yQHl09OJ9pNM5QEmMW0dwOrjGxMKxu_m4dNx6Ls2NFY\",
 \"user\":
    {\"first_name\":\"سارا\",
    \"speciality\":\"عمومی\",
    \"password\":\"$2a$10$4Xqu2fAe8.QmzLB/3djSA.iQHx.OOTYtl9YSCxrg2ty.iIUp.TwRm\",
    \"last_name\":\"بابایی\",
    \"phone\":\"09190307668\"}}
*/

/*
{\"message\":\"success\",
 \"token\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjo0LCJmaXJzdF9uYW1lIjoi2LTYp9uM2KfZhiIsImxhc3RfbmFtZSI6Itio2KfYqNin24zbjCIsInBob25lIjoiMDk5MTEyNDU5MjIiLCJwYXNzd29yZCI6IiQyYSQxMCRJLlBlNzFHU0wyWnN0NERvWHFQZTAuUDY3cUVMZmdWUk5aclRxVldPMkc5TnlOUVFaSjZteSIsImltYWdlIjpudWxsLCJkYXRlX3RpbWUiOiIyMDIxLTAyLTA3VDE3OjE5OjQ1Ljc2MloifSwiaWF0IjoxNjEyNzE4NTA0fQ.oU6Uz9iRQSRgEhFXVx7Rad5vyRFSyM0hqAM_eyvRduI\",
 \"user\":
    {\"id\":4,
    \"first_name\":\"شایان\",
    \"last_name\":\"بابایی\",
    \"phone\":\"09911245922\",
    \"password\":\"$2a$10$I.Pe71GSL2Zst4DoXqPe0.P67qELfgVRNZrTqVWO2G9NyNQQZJ6my\",
    \"image\":null,
    \"date_time\":\"2021-02-07T17:19:45.762Z\"}}
*/

/*
{\"message\":\"success\",
 \"token\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjo1LCJmaXJzdF9uYW1lIjoi2LPYp9ix2KciLCJsYXN0X25hbWUiOiLYqNin2KjYp9uM24wiLCJwaG9uZSI6IjA5MTkwMzA3NjY4IiwicGFzc3dvcmQiOiIkMmEkMTAkNFhxdTJmQWU4LlFtekxCLzNkalNBLmlRSHguT09UWXRsOVlTQ3hyZzJ0eS5pSVVwLlR3Um0iLCJpbWFnZSI6bnVsbCwiZGF0ZV90aW1lIjoiMjAyMS0wMi0wOVQxMTo0Mjo1NS41MDJaIn0sImlhdCI6MTYxMjg3MjA4Nn0.T04DnYVSobLU373DmDPA5ke1KJhyprpV1jWvogLb15A\",
 \"user\":
    {\"id\":5,
    \"first_name\":\"سارا\",
    \"last_name\":\"بابایی\",
    \"phone\":\"09190307668\",
    \"password\":\"$2a$10$4Xqu2fAe8.QmzLB/3djSA.iQHx.OOTYtl9YSCxrg2ty.iIUp.TwRm\",
    \"image\":null,
     \"date_time\":\"2021-02-09T11:42:55.502Z\"}}
 */
