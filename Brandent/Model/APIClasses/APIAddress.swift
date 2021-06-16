//
//  APIAddress.swift
//  Brandent
//
//  Created by Sara Babaei on 11/20/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

struct APIAddress {
    //MARK: Clinitick Server
//    185.235.40.77:7000
    private static let server = "https://app.clinitick.com/"
    private static let base = APIAddress.server + "api/"
    
    private static let sync = APIAddress.base + "sync"
    
    private static let patient = APIAddress.base + "patients"
    public static let images = APIAddress.patient + "/images"
    public static let compressedImageFiles = APIAddress.server + "public/refined/"
    public static let realImageFiles = APIAddress.server + "public/uploads/"
    
    private static let authentication = APIAddress.base + "auth/"
    private static let login = APIAddress.authentication + "login"
    private static let signUp = APIAddress.authentication + "register"
    private static let sendPhone = APIAddress.signUp + "/phone"
    private static let sendCode = APIAddress.signUp + "/code"
    
    private static let dentist = APIAddress.base + "dentists"
    private static let dentistProfile = APIAddress.dentist + "/profile"
    private static let profilePicture = APIAddress.dentistProfile + "/image"
    public static let profilePictureFile = APIAddress.compressedImageFiles + "profile/"
    
    static let addImageURL = URL(string: APIAddress.images)!
    static let syncURL = URL(string: APIAddress.sync)!
    static let loginURL = URL(string: APIAddress.login)!
    static let signUpURL = URL(string: APIAddress.signUp)!
    static let sendPhoneURL = URL(string: APIAddress.sendPhone)!
    static let sendCodeURL = URL(string: APIAddress.sendCode)!
    static let profilePictureURL = URL(string: APIAddress.profilePicture)!
    
    //MARK: Clinitick Blog
    private static let blogServer = "https://blog.clinitick.com/"
    private static let blogBase = APIAddress.blogServer + "wp-json/wp/v2/"
    
    private static let posts = APIAddress.blogBase + "posts"
    
    public static let media = APIAddress.blogServer + "media/"
    
    static let listPostsURL = URL(string: APIAddress.posts)!
    
    //MARK: Clinitick Navigation
    private static let aboutUs = "https://www.clinitick.com"
    private static let subscribe = "https://auth.clinitick.com"
    
    static let aboutUsURL = URL(string: APIAddress.aboutUs)!
    static let subscribeURL = URL(string: APIAddress.subscribe)!
}

//TODO: /uploads/... —> /refined/...
