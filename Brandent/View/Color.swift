//
//  Color.swift
//  Brandent
//
//  Created by Sara Babaei on 10/10/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

enum Color {
    case gray
    case red
    case orange
    case green
    case pink
    case purple
    case darkBlue
    case lightBlue
    case indigo
    case darkGreen
    case lightGreen
    
    //MARK: Component Colors
    var componentColor: UIColor {
        switch self {
        case .red:
            return UIColor(red: 224/255, green: 32/255, blue: 32/255, alpha: 1)
        case .orange:
            return UIColor(red: 255/255, green: 118/255, blue: 3/255, alpha: 1)
        case .green:
            return UIColor(red: 107/255, green: 207/255, blue: 0, alpha: 1)
        case .gray:
            return UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
        default:
            return UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
        }
    }
    
    var clinicColor: UIColor {
        switch self {
        case .red:
            return UIColor(red: 255/255, green: 41/255, blue: 39/255, alpha: 1)
        case .pink:
            return UIColor(red: 252/255, green: 36/255, blue: 121/255, alpha: 1)
        case .purple:
            return UIColor(red: 112/255, green: 51/255, blue: 191/255, alpha: 1)
        case .darkBlue:
            return UIColor(red: 0, green: 152/255, blue: 253/255, alpha: 1)
        case .lightBlue:
            return UIColor(red: 0, green: 192/255, blue: 218/255, alpha: 1)
        case .indigo:
            return UIColor(red: 0, green: 153/255, blue: 137/255, alpha: 1)
        case .darkGreen:
            return UIColor(red: 23/255, green: 178/255, blue: 67/255, alpha: 1)
        case .lightGreen:
            return UIColor(red: 126/255, green: 198/255, blue: 48/255, alpha: 1)
        default:
            return UIColor(red: 126/255, green: 198/255, blue: 48/255, alpha: 1)
        }
    }
    
    var menuItemColor: UIColor {
        switch self {
        case .green:
            return UIColor(red: 0, green: 198/255, blue: 118/255, alpha: 1)
        case .pink:
            return UIColor(red: 255/255, green: 111/255, blue: 107/255, alpha: 1)
        default:
            return UIColor.white
        }
    }
    
}
