//
//  RestAPIManager.swift
//  Brandent
//
//  Created by Sara Babaei on 10/21/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class RestAPIManagr {
    
    static let sharedInstance = RestAPIManagr()

    //MARK: Sending A Request
    private func sendRequest(request: URLRequest, type: APIRequestType) {
        let session = URLSession(configuration: .default)
        var code = 0
        var result: Data?
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                result = data
                let responseString = String(data: data, encoding: .utf8)
                print("My response --> \(String(describing: responseString))")
            }
            code = self.checkResponse(response: response as? HTTPURLResponse, error: error)
        }
        task.resume()
        while true {
            if code != 0, let data = result { //task.state == .completed
                action(response: code, data: data, requestType: type)
                return
            }
        }
    }
    
    //MARK: Processing Response
    private func checkResponse(response: HTTPURLResponse?, error: Error?) -> Int {
        if error == nil, let response = response { //toast
            print("response: \(response.debugDescription)")
            return response.statusCode
        }
        print("Error0 \(error.debugDescription)")
        return 1
    }
        
    private func action(response: Int, data: Data, requestType: APIRequestType) {
        print("response: \(response)")
        if response != 200 {
            return
        }
        switch requestType {
        case .sync:
            saveNewData(data: data)
        default:
            return
        }
    }
    
    //MARK: Creating A Request
    private func createRequest(url: URL, params: [String: Any], contentType: ContentType) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData
        let bodyString = String(data: request.httpBody!, encoding: .utf8)
        print("Body: \(bodyString)")
        request.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
//        request.addValue("10", forHTTPHeaderField: "Authorization") //10 should be token
        request.addValue("1", forHTTPHeaderField: "dentist_id")
        return request
    }
    
    //MARK: Creating Specific Request
    private func createAddAppointmentRequest(appointment: Appointment) -> URLRequest {
        let params: [String: Any] = [
            "appointment": appointment.toDictionary(),
            "patient": appointment.patient.toDictionary()]
        return createRequest(url: API.addAppointmentURL, params: params as [String : Any], contentType: .json)
    }
    
    @available(iOS 13.0, *)
    private func createAddFinanceRequest(finance: Finance) -> URLRequest {
        let params: [String: Any] = [
            "dentist_id": "1",
            "finance": finance.toDictionary()]
        return createRequest(url: API.addFinanceURL, params: params, contentType: .json)
    }
    
    private func createAddClinicRequest(clinic: Clinic) -> URLRequest {
        let params: [String: Any] = [
            "clinic": clinic.toDictionary()]
        return createRequest(url: API.addClinicURL, params: params, contentType: .json)
    }
    
    private func createSyncRequest(clinics: [Clinic]?, patients: [Patient]?, finances: [Finance]?, diseases: [Disease]?, appointments: [Appointment]?) -> URLRequest {
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
        return createRequest(url: API.syncURL, params: params, contentType: .json)
    }
    
    //MARK: Images
    private func createAddImagesRequest(appointmentID: UUID, images: [Image]) -> URLRequest {
        let boundary = "Boundary-\(UUID().uuidString)"

        var request = URLRequest(url: API.addImageURL)
        request.httpMethod = "POST"
        request.setValue("\(ContentType.multipart.rawValue); boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let httpBody = NSMutableData()
        httpBody.appendString(convertFormField(key: APIKey.images.id!, value: appointmentID.uuidString, using: boundary))
        for image in images {
            httpBody.append(convertFileData(key: APIKey.images.rawValue, fileName: image.name, mimeType: "image/jpeg", fileData: image.data, using: boundary))
        }
        httpBody.appendString("--\(boundary)--")
        request.httpBody = httpBody as Data
        return request
    }
    
    private func createDeleteImageRequest(appointmentID: UUID, image: Image) -> URLRequest? {
//        URL(string: "\(API.deleteImage)?apt_id=\(appointmentID)&image_id=\(image.name)")
        guard let url = URL(string: "?apt_id=\(appointmentID)&image_id=\(image.name)", relativeTo: API.addImageURL) else {
            print("Error in creating URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return request
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
    
    //MARK: Functions
    func addAppointment(appointment: Appointment) {
        sendRequest(request: createAddAppointmentRequest(appointment: appointment), type: .addAppointment)
    }
    
    func addImage(appointmentID: UUID, images: [Image]) {
        sendRequest(request: createAddImagesRequest(appointmentID: appointmentID, images: images), type: .addImage)
    }
    
    func deleteImage(appointmentID: UUID, image: Image) {
        if let request = createDeleteImageRequest(appointmentID: appointmentID, image: image) {
            sendRequest(request:request, type: .addImage )
        }
    }
    
    func addFinance(finance: Finance) {
        sendRequest(request: createAddFinanceRequest(finance: finance), type: .addFinance)
    }
    
    func addClinic(clinic: Clinic) {
        sendRequest(request: createAddClinicRequest(clinic: clinic), type: .addClinic)
    }
    
    func sync(clinics: [Clinic]?, patients: [Patient]?, finances: [Finance]?, diseases: [Disease]?, appointments: [Appointment]?) {
        sendRequest(request: createSyncRequest(clinics: clinics, patients: patients, finances: finances, diseases: diseases, appointments: appointments), type: .sync)
    }
    
    func saveNewData(data: Data) {
        guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
            print("Could not save new data")
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
    
    func getArray(data: NSDictionary, key: String) -> NSArray? {
        return data[key] as? NSArray
    }
    
    func saveArray(array: NSArray, key: APIKey) {
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
