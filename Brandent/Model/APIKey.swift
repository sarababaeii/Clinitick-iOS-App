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
    
    var isDeleted: String? {
        switch self {
        case .appointment, .finance:
            return "is_deleted"
        default:
            return nil
        }
    }
    var title: String? {
        switch self {
        case .clinic, .finance, .disease:
            return "title"
        default:
            return nil
        }
    }
    
    var address: String? {
        switch self {
        case .clinic:
            return "address"
        default:
            return nil
        }
    }
    
    var name: String? {
        switch self {
        case .patient:
            return "full_name"
        default:
            return nil
        }
    }
    
    var phone: String? {
        switch self {
        case .patient:
            return "phone"
        default:
            return nil
        }
    }
    
    var isCost: String? {
        switch self {
        case .finance:
            return "is_cost"
        default:
            return nil
        }
    }
    
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
    
    var notes: String? {
        switch self {
        case .appointment:
            return "notes"
        default:
            return nil
        }
    }
    
    var state: String? {
        switch self {
        case .appointment:
            return "state"
        default:
            return nil
        }
    }
    
    var disease: String? {
        switch self {
        case .appointment:
            return "disease"
        default:
            return nil
        }
    }
    
    var clinic: String? {
        switch self {
        case .appointment:
            return "clinic_id"
        default:
            return nil
        }
    }
    
    var alergies: String? {
        switch self {
        case .appointment:
            return "state"
        default:
            return nil
        }
    }
    
    var patient: String? {
        switch self {
        case .appointment:
            return "patient_id"
        default:
            return nil
        }
    }
}
