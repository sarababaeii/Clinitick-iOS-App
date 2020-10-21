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
        private static let appointment = API.base + "appointments/"
        private static let add = API.appointment + "add"
            
        static let addAppointmentURL = URL(string: API.add)!
    }
    
    static let sharedInstance = RestAPIManagr()
    
//    var accessToken: String?
//    var refreshToken: String?
    
    //MARK: Creating A Request
    func createRequest(url: URL, params: [String: Any]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = params.map{ "\($0)=\($1)" }
            .joined(separator: "&")
        request.httpBody = body.data(using: .utf8)

//        http://185.235.40.77:7000/api/appointmentadd
        print("^^ \(request)")
        print("## \(String(describing: request.httpBody))")
        return request
    }
    
    func createAddAppointmentRequest(appointment: Appointment) -> URLRequest {
        let params = [
            "id": appointment.id as Any,
            "notes": appointment.notes as Any,
            "price": appointment.price as Any,
            "state": appointment.state,
            "visit_time": appointment.visit_time.toDBFormatString(),
            "disease": appointment.disease?.title as Any,
            "is_deleted": false,
//            "clinic_id": appointment.clinic?.id as Any,
            "clinic_id": "890a32fe-12e6-11eb-adc1-0242ac120002",
            "allergies": appointment.patient.alergies as Any,
            "full_name": appointment.patient.name as Any,
            "phone": appointment.patient.phone]
        
        print("params: \(params)")
        return createRequest(url: API.addAppointmentURL, params: params as [String : Any])
    }
    
//    "appointment = {
//        "id":"890a32fe-12e6-11eb-adc1-0242ac120002",
//        "notes":"had a surgery last month",
//        "price":5000000,
//        "state":"done",
//        "visit_time":"2020-10-20 17:05:30",
//        "disease":"checkup",
//        "is_deleted":false,
//        "clinic_id":"890a32fe-12e6-11eb-adc1-0242ac120002",
//        "allergies":"peanut butter",
//        "full_name":"John Smith",
//        "phone":"09123456789"
//    }"
    
    //MARK: Posting A Request
    func postRequest(request: URLRequest) {
        let session = URLSession(configuration: .default)
        var code = 0
        
        let task = session.dataTask(with: request) { (data, response, error) in
//            self.setToken(data: data)
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
            print("response: \(response.debugDescription)")
            return response.statusCode
        }
        print("Error0 \(error.debugDescription)")
        return 1
    }
    
    func action(response: Int) {
        print("response: \(response)")
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
}
