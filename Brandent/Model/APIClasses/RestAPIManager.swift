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
    let jsonSerializer = JSONSerializer()

    //MARK: Sending A Request
    private func sendRequest(request: URLRequest, type: APIRequestType) -> RestAPIResult {
        let req = setTokenInHeader(request: request, type: type)
        let session = URLSession(configuration: .default)
        var result: RestAPIResult?
        let task = session.dataTask(with: req) { (data, response, error) in
            if let data = data {
                let responseString = String(data: data, encoding: .utf8)
                print("My response --> \(String(describing: responseString))")
            }
            result = RestAPIResult(data: data, response: response as? HTTPURLResponse)
        }
        task.resume()
        while true {
            if let result = result {
                return result
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
        print("Body: \(String(describing: bodyString))")
        request.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func setTokenInHeader(request: URLRequest, type: APIRequestType) -> URLRequest {
        guard type != .login && type != .signUp, let token = Info.sharedInstance.token else {
            return request
        }
        var newRequest = request
        newRequest.addValue(token, forHTTPHeaderField: "token") //key?
        print(token)
        return newRequest
    }
    
    //MARK: Creating Specific Request
    private func createLoginRequest(phone: String, password: String) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getLoginData(phone: phone, password: password)
        return createRequest(url: API.loginURL, params: params as [String: Any], contentType: .json)
    }
    
    private func createSignUpRequest(dentist: DummyDentist) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getSignUpData(dentist: dentist)
        return createRequest(url: API.signUpURL, params: params as [String: Any], contentType: .json)
    }
    
    private func createSendPhoneRequest(phone: String) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getsendPhoneData(phone: phone)
        return createRequest(url: API.sendPhoneURL, params: params as [String: Any], contentType: .json)
    }
    
    private func createSendOneTimeCodeRequest(phone: String, code: String) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getSendCodeData(phone: phone, code: code)
        return createRequest(url: API.sendCodeURL, params: params as [String: Any], contentType: .json)
    }
    
    private func createAddAppointmentRequest(appointment: Appointment) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getAddAppointmentData(appointment: appointment)
        return createRequest(url: API.addAppointmentURL, params: params as [String: Any], contentType: .json)
    }
    
    private func createAddFinanceRequest(finance: Finance) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getAddFinanceData(finance: finance)
        return createRequest(url: API.addFinanceURL, params: params, contentType: .json)
    }
    
    private func createAddClinicRequest(clinic: Clinic) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getAddClinicData(clinic: clinic)
        return createRequest(url: API.addClinicURL, params: params, contentType: .json)
    }
    
    private func createSyncRequest(clinics: [Clinic]?, patients: [Patient]?, finances: [Finance]?, tasks: [Task]?, diseases: [Disease]?, appointments: [Appointment]?) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getSyncData(clinics: clinics, patients: patients, finances: finances, tasks: tasks, diseases: diseases, appointments: appointments)
        return createRequest(url: API.syncURL, params: params, contentType: .json)
    }
    
    //MARK: Images
    private func createAddImagesRequest(url: URL, key: APIKey, images: [Image]) -> URLRequest {
        let boundary = "Boundary-\(UUID().uuidString)"

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(ContentType.multipart.rawValue); boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonSerializer.getAddImageData(key: key, images: images, boundary: boundary)
        return request
    }
    
    private func createDeleteImageRequest(image: Image) -> URLRequest? {
        guard let url = URL(string: "\(API.images)/\(image.name)") else {
            print("Error in creating URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return request
    }
    
    private func createGetImagesRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    //MARK: Authentication
    func login(phone: String, password: String) -> Int {
        let result = sendRequest(request: createLoginRequest(phone: phone, password: password), type: .login)
        return result.authenticate(type: .login, clinicTitle: nil)
    }
    
    func signUp(dentist: DummyDentist) -> Int {
        let result = sendRequest(request: createSignUpRequest(dentist: dentist), type: .signUp)
        return result.authenticate(type: .signUp, clinicTitle: dentist.clinicTitle)
    }
    
    func getOneTimeCode(phone: String) -> Int {
        let result = sendRequest(request: createSendPhoneRequest(phone: phone), type: .sendPhone)
        return result.response?.statusCode ?? 500
    }
    
    func sendOneTimeCode(phone: String, code: String) -> Bool {
        let result = sendRequest(request: createSendOneTimeCodeRequest(phone: phone, code: code), type: .sendCode)
        return result.isCodeValid()
    }
    
    func setProfilePicture(photo: [Image]) {
        let url = API.profilePictureURL
        let _ = sendRequest(request: createAddImagesRequest(url: url, key: .dentist, images: photo), type: .setProfile)
    }
    
    func getProfilePicture() -> Image? {
        let url = API.profilePictureURL
        let result = sendRequest(request: createGetImagesRequest(url: url), type: .setProfile)
        return result.processProfilePicture()
    }
    
    //MARK: Functions
    func addAppointment(appointment: Appointment) {
        let _ = sendRequest(request: createAddAppointmentRequest(appointment: appointment), type: .addAppointment)
    }
    
    func addImage(patientID: UUID, images: [Image]) {
        let url = URL(string: "\(API.images)/\(patientID)")!
        let _ = sendRequest(request: createAddImagesRequest(url: url, key: .patient, images: images), type: .addImage)
    }
    
    func deleteImage(image: Image) {
        if let request = createDeleteImageRequest(image: image) {
            let _ = sendRequest(request:request, type: .addImage )
        }
    }
    
    func getImages(patientID: UUID) -> NSArray? {
        let url = URL(string: "\(API.images)/\(patientID)")!
        let result = sendRequest(request: createGetImagesRequest(url: url), type: .addImage)
        return result.getImages()
    }

    func addFinance(finance: Finance) {
        let _ = sendRequest(request: createAddFinanceRequest(finance: finance), type: .addFinance)
    }
    
    func addClinic(clinic: Clinic) {
        let _ = sendRequest(request: createAddClinicRequest(clinic: clinic), type: .addClinic)
    }
    
    //MARK: Sync
    func sync(clinics: [Clinic]?, patients: [Patient]?, finances: [Finance]?, tasks: [Task]?, diseases: [Disease]?, appointments: [Appointment]?) {
        let result = sendRequest(request: createSyncRequest(clinics: clinics, patients: patients, finances: finances, tasks: tasks, diseases: diseases, appointments: appointments), type: .sync)
        result.saveNewData()
    }
}
