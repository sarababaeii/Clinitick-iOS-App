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
    private func sendRequest(request: URLRequest, type: APIRequestType, _ completion: @escaping (RestAPIResult) -> ()) {
        let req = setTokenInHeader(request: request, type: type)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: req) { (data, response, error) in
            if let data = data {
                let responseString = String(data: data, encoding: .utf8)
                print("\(type)\nMy response --> \(String(describing: responseString))")
            }
            let result = RestAPIResult(data: data, response: response as? HTTPURLResponse)
            completion(result)
        }
        task.resume()
    }
    
    //MARK: Creating A Request
    private func createPostRequest(url: URL, params: [String: Any], contentType: ContentType) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData
        let bodyString = String(data: request.httpBody!, encoding: .utf8)
        print("Body: \(String(describing: bodyString))")
        request.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func createGetRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    private func setTokenInHeader(request: URLRequest, type: APIRequestType) -> URLRequest {
        guard type != .login && type != .signUp, let token = Info.sharedInstance.token else {
            return request
        }
        var newRequest = request
        newRequest.addValue(token, forHTTPHeaderField: "token")
        print(token)
        return newRequest
    }
    
    //MARK: Creating Specific Request
    private func createLoginRequest(phone: String, password: String) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getLoginData(phone: phone, password: password)
        return createPostRequest(url: APIAddress.loginURL, params: params as [String: Any], contentType: .json)
    }
    
    private func createSignUpRequest(dentist: DummyDentist) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getSignUpData(dentist: dentist)
        return createPostRequest(url: APIAddress.signUpURL, params: params as [String: Any], contentType: .json)
    }
    
    private func createResetPassRequest(phone: String, password: String, token: String) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getResetPassData(phone: phone, password: password, token: token)
        return createPostRequest(url: APIAddress.forgetPassSendPassURL, params: params as [String: Any], contentType: .json)
    }
    
    private func createSendPhoneRequest(phone: String, for type: APIRequestType) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getsendPhoneData(phone: phone)
        if type == .sendPhone {
            return createPostRequest(url: APIAddress.sendPhoneURL, params: params as [String: Any], contentType: .json)
        }
        return createPostRequest(url: APIAddress.forgetPassSendPhoneURL, params: params as [String: Any], contentType: .json)
    }
    
    private func createSendOneTimeCodeRequest(phone: String, code: String, for type: APIRequestType) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getSendCodeData(phone: phone, code: code)
        if type == .sendCode {
            return createPostRequest(url: APIAddress.sendCodeURL, params: params as [String: Any], contentType: .json)
        }
        return createPostRequest(url: APIAddress.forgetPassSendCodeURL, params: params as [String: Any], contentType: .json)
    }
    
    private func createSyncRequest(clinics: [Clinic]?, patients: [Patient]?, finances: [Finance]?, tasks: [Task]?, appointments: [Appointment]?) -> URLRequest {
        let params: [String: Any] = jsonSerializer.getSyncData(clinics: clinics, patients: patients, finances: finances, tasks: tasks, appointments: appointments)
        return createPostRequest(url: APIAddress.syncURL, params: params, contentType: .json)
    }
    
    private func createListPostsRequest() -> URLRequest {
        return createGetRequest(url: APIAddress.listPostsURL)
    }
    
    private func createGetPostImageRequest(imageID: String) -> URLRequest? {
        guard let url = URL(string: "\(APIAddress.media)\(imageID)") else {
            return nil
        }
        print("IMAGE URL")
        print(url)
        print("@@@")
        return createGetRequest(url: url)
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
        guard let url = URL(string: "\(APIAddress.images)/\(image.name)") else {
            print("Error in creating URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return request
    }
    
    private func createGetImagesRequest(url: URL) -> URLRequest {
        return createGetRequest(url: url)
    }
    
    //MARK: Authentication
    func login(phone: String, password: String, _ completion: @escaping (Int) -> ()) {
        sendRequest(request: createLoginRequest(phone: phone, password: password), type: .login, {(result) in
            let code = result.authenticate(type: .login, dummyDentist: nil)
            DispatchQueue.main.async {
                completion(code)
            }
        })
    }
    
    func signUp(dentist: DummyDentist,  _ completion: @escaping (Int) -> ()) {
        sendRequest(request: createSignUpRequest(dentist: dentist), type: .signUp, {(result) in
            let code = result.authenticate(type: .signUp, dummyDentist: dentist)
            DispatchQueue.main.async {
                completion(code)
            }
        })
    }
    
    func resetPassword(phone: String, password: String, token: String, _ completion: @escaping (Int) -> ()) {
        sendRequest(request: createResetPassRequest(phone: phone, password: password, token: token), type: .forgetSendPass, {(result) in
            let code = result.authenticate(type: .login, dummyDentist: nil)
            DispatchQueue.main.async {
                completion(code)
            }
        })
    }
    
    func getOneTimeCode(phone: String, for type: APIRequestType, _ completion: @escaping (Int) -> ()) {
        sendRequest(request: createSendPhoneRequest(phone: phone, for: type), type: type, {(result) in
            let code = result.response?.statusCode ?? 500
            DispatchQueue.main.async {
                completion(code)
            }
        })
    }
    
    func sendOneTimeCode(phone: String, code: String, for type: APIRequestType, _ completion: @escaping (Bool, String?) -> ()) {
        sendRequest(request: createSendOneTimeCodeRequest(phone: phone, code: code, for: type), type: .sendCode, {(result) in
            let isCodeValid = result.isCodeValid()
            DispatchQueue.main.async {
                completion(isCodeValid, result.getResetPassToken())
            }
        })
    }
    
    func setProfilePicture(photo: [Image]) {
        let url = APIAddress.profilePictureURL
        sendRequest(request: createAddImagesRequest(url: url, key: .dentist, images: photo), type: .setProfile, {(result) in})
    }
    
    func getProfilePicture(_ completion: @escaping (Image?) -> ()) {
        let url = APIAddress.profilePictureURL
        sendRequest(request: createGetImagesRequest(url: url), type: .setProfile, {(result) in
            let image = result.processProfilePicture()
            completion(image)
        })
    }
    
    //MARK: Images Functions
    func addImage(patientID: UUID, images: [Image]) {
        let url = URL(string: "\(APIAddress.images)/\(patientID)")!
        sendRequest(request: createAddImagesRequest(url: url, key: .patient, images: images), type: .addImage, {(result) in
                DispatchQueue.main.async {
                    result.showToastResponse()
                }
        })
    }
    
    func deleteImage(image: Image) {
        if let request = createDeleteImageRequest(image: image) {
            sendRequest(request:request, type: .addImage, {(result) in
                DispatchQueue.main.async {
                    result.showToastResponse()
                }
            })
        }
    }
    
    func getImages(patientID: UUID, _ completion: @escaping (NSArray?) -> ()) {
        let url = URL(string: "\(APIAddress.images)/\(patientID)")!
        sendRequest(request: createGetImagesRequest(url: url), type: .addImage, {(result) in
            let images = result.getImages()
            if let imgs = images {
                DispatchQueue.main.async {
                    UIApplication.topViewController()?.showToast(message: "\(String(imgs.count).convertEnglishNumToPersianNum()) تصویر دریافت شد.")
                }
            } else {
                DispatchQueue.main.async {
                    result.showToastResponse()
                }
            }
            completion(images)
        })
    }
    
    //MARK: Sync
    func sync(clinics: [Clinic]?, patients: [Patient]?, finances: [Finance]?, tasks: [Task]?, appointments: [Appointment]?) {
        sendRequest(request: createSyncRequest(clinics: clinics, patients: patients, finances: finances, tasks: tasks, appointments: appointments), type: .sync, {(result) in
            result.saveNewData()
            result.processOldData(clinics: clinics, patients: patients, finances: finances, tasks: tasks, appointments: appointments)
        })
    }
    
    //MARK: Blog
    func getBlogPosts(_ completion: @escaping (NSArray?) -> ()) {
        sendRequest(request: createListPostsRequest(), type: .listBlogPosts, {(result) in
            let postsResult = result.listPosts()
            completion(postsResult)
        })
    }
    
    func getPostImageLink(imageID: String, _ completion: @escaping (String?) -> ()) {
        if let request = createGetPostImageRequest(imageID: imageID) {
            sendRequest(request: request, type: .getPostImage, {(result) in
                let imageLink = result.getImageLink()
                print("IMAGE LINK:")
                print(imageLink as Any)
                print("$$$")
                completion(imageLink)
            })
        }
    }
}
