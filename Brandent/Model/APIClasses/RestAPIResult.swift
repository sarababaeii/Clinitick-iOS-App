//
//  RestAPIResult.swift
//  Brandent
//
//  Created by Sara Babaei on 12/16/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

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
    
    func authenticate(type: APIRequestType, dummyDentist: DummyDentist?) -> Int {
        guard let response = response, let data = data else {
            return 500
        }
        if response.statusCode != 200 {
            return response.statusCode
        }
        saveData(data: data, dummyDentist: dummyDentist)
        return 200
    }
    
    private func saveData(data: Data, dummyDentist: DummyDentist?) {
        guard let dictionary = jsonSerializer.decodeData(data: data) else {
            return
        }
        saveToken(dictionary: dictionary)
        saveDentist(dictionary: dictionary, dummyDentist: dummyDentist)
    }
    
    private func saveToken(dictionary: NSDictionary) {
        guard let token = dictionary["token"] as? String else {
            return
        }
        Info.sharedInstance.token = token
    }
    
    private func saveDentist(dictionary: NSDictionary, dummyDentist: DummyDentist?) {
        print("Is saving dentist")
        guard let user = dictionary["user"] as? [String: Any],
            let id = user["id"] as? Int,
            let firstName = user["first_name"] as? String,
            let lastName = user["last_name"] as? String,
            let phone = user["phone"] as? String,
            let speciality = user["speciality"] as? String else {
                print("COULD NOT SAVE DENTIST")
//                DispatchQueue.main.async {
//                UIApplication.topViewController()?.showToast(message: "Could Not Save DENTIST")
//            }
                return
        }
        
        let dentist = Dentist.getDentist(id: NSDecimalNumber(value: id), firstName: firstName, lastName: lastName, phone: phone, speciality: speciality)
        print("DENTIST SAVED SUCCESSFULLY \(dentist)")
        
        Info.sharedInstance.dentistID = id
        setClinic(clinicTitle: dummyDentist?.clinicTitle)
        setProfilePicture(image: dummyDentist?.profilePicture)
        saveProfilePicture(dictionary: user)
        Info.sharedInstance.sync()
    }
    
    private func setClinic(clinicTitle: String?) {
        if let dentist = Info.sharedInstance.dentist, let clinicTitle = clinicTitle {
            dentist.setClinic(clinicTitle: clinicTitle)
        }
    }
    
    private func setProfilePicture(image: Image?) {
        if let image = image {
            if let dentist = Info.sharedInstance.dentist {
                dentist.setProfilePicture(photo: image, fromAPI: false)
            }
        }
    }
    
    private func saveProfilePicture(dictionary: [String: Any]) {
        if let dentist = Info.sharedInstance.dentist, let photo = getProfilePictureFile(dictionary: dictionary) {
            dentist.setProfilePicture(photo: photo, fromAPI: true)
        }
    }
    
    //MARK: Profile Photo
    func processProfilePicture() -> Image? {
        if response?.statusCode != 200 {
            print("Error in getting profile picture")
            return nil
        }
        guard let data = data, let result = jsonSerializer.decodeData(data: data), let dictionary = result as? [String: Any] else {
            return nil
        }
        return getProfilePictureFile(dictionary: dictionary)
    }
    
    private func getProfilePictureFile(dictionary: [String: Any]) -> Image? {
        guard let fileName = dictionary["image"] as? String else {
            return nil
        }
        let image = Image(name: fileName, urlString: APIAddress.profilePictureFile)
        return image
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
        let keys: [APIKey] = [.patient, .clinic, .finance, .appointment, .task]
        for i in 0 ..< keys.count {
            print("is saving \(keys[i])s")
            if let array = getArray(data: result, key: keys[i].sync!) {
                if !saveArray(array: array, key: keys[i], at: date) {
                    print("could not save \(keys[i].rawValue)")
//                    DispatchQueue.main.async {
//                        UIApplication.topViewController()?.showToast(message: "Could Not Save \(keys[i].rawValue)")
//                    }
                    return
                }
            }
        }
        Info.sharedInstance.dentist?.last_update = timeString
//        DispatchQueue.main.async {
//            UIApplication.topViewController()?.showToast(message: "Sync Completed Successfully")
//        }
    }
    
    private func getArray(data: NSDictionary, key: String) -> NSArray? {
        return data[key] as? NSArray
    }
    
    private func saveArray(array: NSArray, key: APIKey, at date: Date) -> Bool {
        for item in array {
            var wasSuccessfull = false
            if let dictionary = item as? NSDictionary {
                print(key)
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
    
    //MARK: Blog
    func listPosts() -> NSArray? {
        if response?.statusCode != 200 {
            return nil
        }
        guard let data = data, let result = jsonSerializer.decodeDataToArray(data: data) else {
            return nil
        }
        return result
    }
    
    func getImageLink() -> String? {
        if response?.statusCode != 200 {
            return nil
        }
        guard let data = data, let result = jsonSerializer.decodeData(data: data), let linkContainer = result["guid"] as? NSDictionary, let link = linkContainer["rendered"] as? String else {
            return nil
        }
        return link
    }
}

//TODO: Name constraint for sync
