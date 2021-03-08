//
//  APIAddress.swift
//  Brandent
//
//  Created by Sara Babaei on 11/20/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

struct API {
    private static let server = "http://185.235.40.77:7000/"
    private static let base = API.server + "api/"
    
    private static let sync = API.base + "sync"
    
    private static let patient = API.base + "patients"
    public static let images = API.patient + "/images"
    public static let imageFiles = API.server + "public/refined/"
    
    private static let authentication = API.base + "auth/"
    private static let login = API.authentication + "login"
    private static let signUp = API.authentication + "register"
    private static let sendPhone = API.signUp + "/phone"
    private static let sendCode = API.signUp + "/code"
    
    private static let dentist = API.base + "dentists"
    private static let dentistProfile = API.dentist + "/profile"
    private static let profilePicture = API.dentistProfile + "/image"
    public static let profilePictureFile = API.imageFiles + "profile/"
    
    static let addImageURL = URL(string: API.images)!
    static let syncURL = URL(string: API.sync)!
    static let loginURL = URL(string: API.login)!
    static let signUpURL = URL(string: API.signUp)!
    static let sendPhoneURL = URL(string: API.sendPhone)!
    static let sendCodeURL = URL(string: API.sendCode)!
    static let profilePictureURL = URL(string: API.profilePicture)!
}

//TODO: /uploads/... —> /refined/...
