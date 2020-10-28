//
//  AlertMessage.swift
//  Brandent
//
//  Created by Sara Babaei on 10/28/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

enum AlertMessage {
    case camera
    case photos
    
    var noPermission: String {
        let firstSentence = "Looks like Brandent doesn't have access to your"
        let secondSentence = ". Please use Settings App on your device to permit Brandent accessing your"
        
        switch self {
        case .camera:
            return "\(firstSentence) camera\(secondSentence) camera."
        case .photos:
            return "\(firstSentence) photos\(secondSentence) photos."
        }
    }
    
    var trouble: String {
        let firstPhrase = "Sincere apologies, it looks like we can't access your"
        let secondPhrase = "at this time."
        
        switch self {
        case .camera:
            return "\(firstPhrase) camera \(secondPhrase)"
        case .photos:
            return "\(firstPhrase) photos \(secondPhrase)"
        }
    }
}
