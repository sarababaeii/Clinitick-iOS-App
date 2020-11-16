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
        //TODO: Get finances are remained
    }
    
    private enum ContentType: String {
        case json = "application/json"
        case multipart = "multipart/form-data"
    }
    
    static let sharedInstance = RestAPIManagr()
//    var accessToken: String?
//    var refreshToken: String?
    
    //MARK: Posting A Request
    private func postRequest(request: URLRequest) {
        let session = URLSession(configuration: .default)
        var code = 0
        
        let task = session.dataTask(with: request) { (data, response, error) in
//            self.setToken(data: data)
            if let data = data {
                let responseString = String(data: data, encoding: .utf8)
                print("My response --> \(String(describing: responseString))")
            }
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
    private func createRequest(url: URL, params: [String: Any], contentType: ContentType) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData
        
        let bodyString = String(data: request.httpBody!, encoding: .utf8)
        print("body: \(bodyString) ^^")

        request.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
//        request.addValue("10", forHTTPHeaderField: "Authorization") //10 should be token
        request.addValue("1", forHTTPHeaderField: "dentist_id")
        
        print(url)
        return request
    }
    
    //MARK: Creating Specific Request
    private func createAddAppointmentRequest(appointment: Appointment) -> URLRequest {
        let params: [String: Any] = [
            "appointment": appointment.toDictionary(),
            "patient": appointment.patient.toDictionary()]
        print("params: \(params)")
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
            "clinic": clinic.toDictionary()
        ]
        return createRequest(url: API.addClinicURL, params: params, contentType: .json)
    }
    
    private func createSyncRequest(clinics: [Clinic]?, patients: [Patient]?, finances: [Finance]?, diseases: [Disease]?, appointments: [Appointment]?) -> URLRequest {
        var params = [String: Any]()
        if let lastUpdate = Info.sharedInstance.lastUpdate {
            params["last_updated"] = lastUpdate
        }
        if let clinics = clinics {
            params["clinics"] = Clinic.toDictionaryArray(clinics: clinics)
        }
        if let patients = patients {
            params["patients"] = Patient.toDictionaryArray(patients: patients)
        }
        if let finances = finances {
            params["finances"] = Finance.toDictionaryArray(finances: finances)
        }
        if let diseases = diseases {
            params["diseases"] = Disease.toDictionaryArray(diseases: diseases)
        }
        if let appointments = appointments {
            params["appointments"] = Appointment.toDictionaryArray(appointments: appointments)
        }
        print("^^ Sync Request Is Going To Be Created ^")
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
    
    private func checkResponse(response: HTTPURLResponse?, error: Error?) -> Int {
        if error == nil, let response = response {
            print("@@ response: \(response.debugDescription) @")
            return response.statusCode
        }
        print("@@ Error0 \(error.debugDescription) @")
        return 1
    }
    
    private func action(response: Int) {
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
    
    func addClinic(clinic: Clinic) {
        postRequest(request: createAddClinicRequest(clinic: clinic))
    }
    
    func sync(clinics: [Clinic]?, patients: [Patient]?, finances: [Finance]?, diseases: [Disease]?, appointments: [Appointment]?) {
        print("^^ Sync Called ^")
        postRequest(request: createSyncRequest(clinics: clinics, patients: patients, finances: finances, diseases: diseases, appointments: appointments))
    }
}
