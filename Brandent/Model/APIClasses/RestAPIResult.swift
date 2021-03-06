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
        saveProfilePicture(dictionary: user) //TODO: should go otherwhere
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
    func processOldData(clinics: [Clinic]?, patients: [Patient]?, finances: [Finance]?, tasks: [Task]?, appointments: [Appointment]?) {
        guard let response = response, response.statusCode == 200 else {
            return
        }
        Entity.removeDeletedItems(array: clinics)
        Entity.removeDeletedItems(array: patients)
        Entity.removeDeletedItems(array: finances)
        Entity.removeDeletedItems(array: tasks)
        Entity.removeDeletedItems(array: appointments)
    }
    
    func saveNewData() {
        guard let data = data, let result = jsonSerializer.decodeData(data: data) else {
            return
        }
        print(result)
        guard let timeString = result["timestamp"] as? String, let date = Date.getTimeStampFormatDate(from: timeString, isForSync: true) else {
            return
        }
        print("LAST UPDATED: \(date)")
        let keys: [APIKey] = [.clinic, .patient, .finance, .appointment, .task]
        for i in 0 ..< keys.count {
            if let array = getArray(data: result, key: keys[i].sync!) {
                if !saveArray(array: array, key: keys[i], at: date) {
                    print("could not save \(keys[i].rawValue)")
                    return
                }
            }
        }
        Info.sharedInstance.dentist?.last_update = timeString
    }
    
    private func getArray(data: NSDictionary, key: String) -> NSArray? {
        return data[key] as? NSArray
    }
    
    private func saveArray(array: NSArray, key: APIKey, at date: Date) -> Bool {
        for item in array {
            var wasSuccessfull = false
            if let dictionary = item as? NSDictionary {
                switch key {
                case .clinic:
                    wasSuccessfull = Clinic.saveClinic(dictionary, modifiedTime: date)
                case .patient:
                    wasSuccessfull = Patient.savePatient(dictionary, modifiedTime: date)
                case .finance:
                    wasSuccessfull = Finance.saveFinance(dictionary, modifiedTime: date)
                case .appointment:
                    wasSuccessfull = Appointment.saveAppointment(dictionary, modifiedTime: date)
                case .task:
                    wasSuccessfull = Task.saveTask(dictionary, modifiedTime: date)
                default:
                    return false
                }
            }
            if !wasSuccessfull {
                return false
            }
        }
        return true
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
