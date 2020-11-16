//
//  APIKey.swift
//  Brandent
//
//  Created by Sara Babaei on 11/10/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

enum APIKey: String {
    case appointment
    case patient
    case disease
    case clinic
    case finance
    case dentist
    
    case lastUpdate = "last_updated"
    
    //MARK: ID
    var id: String? {
        switch self {
        case .dentist:
            return "dentist_id"
        case .clinic, .disease, .appointment, .patient, .finance:
            return "id"
        default:
            return nil
        }
    }
    
    //MARK: IsDeleted
    var isDeleted: String? {
        switch self {
        case .appointment, .finance:
            return "is_deleted"
        default:
            return nil
        }
    }
    
    //MARK: Title
    var title: String? {
        switch self {
        case .clinic, .finance, .disease:
            return "title"
        default:
            return nil
        }
    }
    
    //MARK: Address
    var address: String? {
        switch self {
        case .clinic:
            return "address"
        default:
            return nil
        }
    }
    
    var color: String? {
        switch self {
        case .clinic:
            return "color"
        default:
            return nil
        }
    }
    
    //MARK: Name
    var name: String? {
        switch self {
        case .patient:
            return "full_name"
        default:
            return nil
        }
    }
    
    //MARK: Phone
    var phone: String? {
        switch self {
        case .patient:
            return "phone"
        default:
            return nil
        }
    }
    
    //MARK: IsCost
    var isCost: String? {
        switch self {
        case .finance:
            return "is_cost"
        default:
            return nil
        }
    }
    
    //MARK: Price
    var price: String? {
        switch self {
        case .appointment, .disease:
            return "price"
        case .finance:
            return "amount"
        default:
            return nil
        }
    }
    
    //MARK: Date
    var date: String? {
        switch self {
        case .appointment:
            return "visit_time"
        case .finance:
            return "date"
        default:
            return nil
        }
    }
    
    //MARK: Notes
    var notes: String? {
        switch self {
        case .appointment:
            return "notes"
        default:
            return nil
        }
    }
    
    //MARK: State
    var state: String? {
        switch self {
        case .appointment:
            return "state"
        default:
            return nil
        }
    }
    
    //MARK: Disease
    var disease: String? {
        switch self {
        case .appointment:
            return "disease"
        default:
            return nil
        }
    }
    
    //MARK: Clinic
    var clinic: String? {
        switch self {
        case .appointment:
            return "clinic_id"
        default:
            return nil
        }
    }
    
    //MARK: Alergies
    var alergies: String? {
        switch self {
        case .appointment:
            return "state"
        default:
            return nil
        }
    }
    
    //MARK: Patient
    var patient: String? {
        switch self {
        case .appointment:
            return "patient_id"
        default:
            return nil
        }
    }
}
