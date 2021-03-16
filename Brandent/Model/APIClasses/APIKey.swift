//
//  APIKey.swift
//  Brandent
//
//  Created by Sara Babaei on 11/10/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

enum APIKey: String {
    case dentist
    case finance
    case task
    case clinic
    case patient
    case appointment
    
    case lastUpdate = "last_updated"
    
    //MARK: Image
    var image: String? {
        switch self {
        case .dentist:
            return "image"
        case .patient:
            return "images"
        default:
            return nil
        }
    }
    
    //MARK: ID
    var id: String? {
        switch self {
        case .clinic, .appointment, .patient, .finance, .dentist, .task:
            return "id"
        default:
            return nil
        }
    }
    
    //MARK: IsDeleted
    var isDeleted: String? { //TODO: Shoul set for other entities
        switch self {
        case .appointment, .finance, .task, .patient, .clinic:
            return "is_deleted"
        default:
            return nil
        }
    }
    
    //MARK: Title
    var title: String? {
        switch self {
        case .clinic, .finance, .task:
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
    
    //MARK: Color
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
        case .dentist:
            return "first_name"
        default:
            return nil
        }
    }
    
    //MARK: Last Name
    var lastName: String? {
        switch self {
        case .dentist:
            return "last_name"
        default:
            return nil
        }
    }
    
    //MARK: Phone
    var phone: String? {
        switch self {
        case .patient, .dentist:
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
        case .appointment:
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
        case .task:
            return "task_date"
        default:
            return nil
        }
    }
    
    //MARK: State
    var state: String? {
        switch self {
        case .appointment, .task:
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
        case .appointment, .task:
            return "clinic_id"
        default:
            return nil
        }
    }
    
    //MARK: Alergies
    var alergies: String? {
        switch self {
        case .patient: //TODO: check
            return "allergies"
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
    
    //MARK: Password
    var password: String? {
        switch self {
        case .dentist:
            return "password"
        default:
            return nil
        }
    }
    
    //MARK: Speciality
    var speciality: String? {
        switch self {
        case .dentist:
            return "speciality"
        default:
            return nil
        }
    }
    
    //MARK: Sync
    var sync: String? {
        switch self {
        case .clinic:
            return "clinics"
        case .patient:
            return "patients"
        case .finance:
            return "finances"
        case .appointment:
            return "appointments"
        case .task:
            return "tasks"
        default:
            return nil
        }
    }
}
