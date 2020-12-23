//
//  JSONSerializer.swift
//  Brandent
//
//  Created by Sara Babaei on 12/16/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

class JSONSerializer {
    
    //MARK: Decoding
    func decodeData(data: Data) -> NSDictionary? {
        if let result = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
            return result
        }
        print("Could not save new data")
        return nil
    }
    
    //MARK: Encoding
    
    
    
    //MARK: Authentication
    func getSignUpData(dentist: Dentist) -> [String: Any] {
        return dentist.toDictionary()
    }
    
    func getLoginData(phone: String, password: String) -> [String: Any] {
        return ["phone": phone,
            "password": password]
    }
    
    func getsendPhoneData(phone: String) -> [String: Any] {
        return ["phone": phone]
    }
    
    func getSendCodeData(phone: String, code: String) -> [String: Any] {
        return ["phone": phone,
          "code": code]
    }
    
    //MARK: Appointment
    func getAddAppointmentData(appointment: Appointment) -> [String: Any] {
        return ["appointment": appointment.toDictionary(),
            "patient": appointment.patient.toDictionary()]
    }
    
    //MARK: Finance
    func getAddFinanceData(finance: Finance) -> [String: Any] {
        return ["dentist_id": "1", //should be deleted?!
            "finance": finance.toDictionary()]
    }
    
    //MARK: Clinic
    func getAddClinicData(clinic: Clinic) -> [String: Any] {
        return ["clinic": clinic.toDictionary()]
    }
    
    //MARK: Sync
    func getSyncData(clinics: [Clinic]?, patients: [Patient]?, finances: [Finance]?, diseases: [Disease]?, appointments: [Appointment]?) -> [String: Any] {
        var params = [String: Any]()
        if let lastUpdate = Info.sharedInstance.lastUpdate {
            params["last_updated"] = lastUpdate
        }
        if let clinics = clinics {
            params[APIKey.clinic.sync!] = Clinic.toDictionaryArray(clinics: clinics)
        }
        if let patients = patients {
            params[APIKey.patient.sync!] = Patient.toDictionaryArray(patients: patients)
        }
        if let finances = finances {
            params[APIKey.finance.sync!] = Finance.toDictionaryArray(finances: finances)
        }
        if let diseases = diseases {
            params[APIKey.disease.sync!] = Disease.toDictionaryArray(diseases: diseases)
        }
        if let appointments = appointments {
            params[APIKey.appointment.sync!] = Appointment.toDictionaryArray(appointments: appointments)
        }
        return params
    }
    
    //MARK: Image
    func getAddImageData(appointmentID: UUID, images: [Image], boundary: String) -> Data {
        let httpBody = NSMutableData()
        httpBody.appendString(convertFormField(key: APIKey.images.id!, value: appointmentID.uuidString, using: boundary))
        for image in images {
            httpBody.append(convertFileData(key: APIKey.images.rawValue, fileName: image.name, mimeType: "image/jpeg", fileData: image.data, using: boundary))
        }
        httpBody.appendString("--\(boundary)--")
        return httpBody as Data
    }
    
    private func convertFormField(key: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(key)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        return fieldString
    }
    
    private func convertFileData(key: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data as Data
    }
}
