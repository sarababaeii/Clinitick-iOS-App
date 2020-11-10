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
    private struct API {
        private static let base = "http://185.235.40.77:7000/api/"
        private static let sync = API.base + "sync"
        private static let appointment = API.base + "appointments/"
        private static let add = API.appointment + "add"
        private static let images = API.add + "images"
        private static let finance = API.base + "finances"
        
        static let addAppointmentURL = URL(string: API.add)!
        static let addImageURL = URL(string: API.images)!
        static let addFinanceURL = URL(string: API.finance)!
        static let syncURL = URL(string: API.sync)!
        //TODO: Get finances are remained
    }
    
    enum ContentType: String {
        case json = "application/json"
        case multipart = "multipart/form-data"
    }
    
    static let sharedInstance = RestAPIManagr()
//    var accessToken: String?
//    var refreshToken: String?
    
    //MARK: Posting A Request
    func postRequest(request: URLRequest) {
        let session = URLSession(configuration: .default)
        var code = 0
        
        let task = session.dataTask(with: request) { (data, response, error) in
//            self.setToken(data: data)
            let responseString = String(data: data!, encoding: .utf8)
            print("My response --> \(String(describing: responseString))")
            code = self.checkResponse(response: response as? HTTPURLResponse, error: error)
        }
        task.resume()
        while true {
            if code != 0 { //task.state == .completed
                action(response: code)
                return
            }
        }
    }
    
    //MARK: Creating A Request
    func createRequest(url: URL, params: [String: Any], contentType: ContentType) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData
        
        let bodyString = String(data: request.httpBody!, encoding: .utf8)
        print("body: \(bodyString) ^^")

        request.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        request.addValue("10", forHTTPHeaderField: "Authorization") //10 should be token
        return request
    }
    
    func createAddAppointmentRequest(appointment: Appointment) -> URLRequest {
        let params: [String: Any] = [
            "appointment": appointment.toDictionary(),
            "patient": [
                "id": appointment.patient.id.uuidString,
                "full_name": appointment.patient.name as Any,
                "phone": appointment.patient.phone],
            "dentist_id": "1"]
//        let params: [String: Any] = [
//            "appointment": [
//                "id": appointment.id.uuidString,
//                "notes": appointment.notes as Any,
//                "price": String(Int(truncating: appointment.price)),
//                "state": appointment.state,
//                "visit_time": appointment.visit_time.toDBFormatDateAndTimeString(),
//                "disease": appointment.disease.title as Any,
//                "is_deleted": "false",
////            "clinic_id": appointment.clinic?.id as Any,
//                "clinic_id": "890a32fe-12e6-11eb-adc1-0242ac120002",
//                "allergies": appointment.patient.alergies as Any],
//            "patient": [
//                "id": appointment.patient.id.uuidString,
//                "full_name": appointment.patient.name as Any,
//                "phone": appointment.patient.phone],
//            "dentist_id": "1"]
        print("params: \(params)")
        return createRequest(url: API.addAppointmentURL, params: params as [String : Any], contentType: .json)
    }
    
    func createAddFinanceRequest(finance: Finance) -> URLRequest {
        let params: [String: Any] = [
            "dentist_id": "1",
            "finance": finance.toDictionary()]
        return createRequest(url: API.addFinanceURL, params: params, contentType: .json)
    }
    
//    func createAddClinicRequest(clinic: Clinic) -> URLRequest {
//        let params: [String: Any] =[]
//        return createRequest(url: API.addClinic, params: params, contentType: .json)
//    }
    
    func createSyncRequest(clinics: [Clinic], patients: [Patient], finances: [Finance], diseases: [Disease], appointments: [Appointment]) -> URLRequest {
        let params: [String: Any] = [
            "last_updated": Info.sharedInstance.lastUpdate.toDBFormatDateAndTimeString(),
            "clinics": Clinic.toDictionaryArray(clinics: clinics),
            "patients": Patient.toDictionaryArray(patients: patients),
            "finances": Finance.toDictionaryArray(finances: finances),
            "diseases": Disease.toDictionaryArray(diseases: diseases),
            "appointments": Appointment.toDictionaryArray(appointments: appointments)
        ]
        return createRequest(url: API.syncURL, params: params, contentType: .json)
    }
    
    //MARK: Processing Response
//    func setToken(data: Data?) {
//        guard let data = data, let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
//            return
//        }
//        print(responseJSON as Any)
//        if let token = responseJSON["access_token"] as? String {
//            accessToken = token
//        }
//        if let token = responseJSON["refresh_token"] as? String {
//            refreshToken = token
//        }
//    }
    
    func checkResponse(response: HTTPURLResponse?, error: Error?) -> Int {
        if error == nil, let response = response {
            print("@@ response: \(response.debugDescription) @")
            return response.statusCode
        }
        print("@@ Error0 \(error.debugDescription) @")
        return 1
    }
    
    func action(response: Int) {
        print("$$ response: \(response) $")
//        if response == 200 {
//            UIApplication.topViewController()?.showNextPage(identifier: "HomeViewController")
//            SocketIOManager.sharedInstance.establishConnection()
//            //TODO: set me
//        } else if response == 401{
//            UIApplication.topViewController()?.showNextPage(identifier: "SignUpViewController")
//        } else {
//            UIApplication.topViewController()?.showToast(message: "Error \(response)")
//        }
    }
    
    //MARK: Functions
    func addAppointment(appointment: Appointment) {
        postRequest(request: createAddAppointmentRequest(appointment: appointment))
    }
    
    func addFinance(finance: Finance) {
        postRequest(request: createAddFinanceRequest(finance: finance))
    }
}
