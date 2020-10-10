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
//    case gray
    case red
    case orange
    
    //MARK: Component Colors
    var componentColor: UIColor {
        switch self {
        case .red:
            return UIColor(red: 224/255, green: 32/255, blue: 32/255, alpha: 1)
        case .orange:
            return UIColor(red: 255/255, green: 118/255, blue: 3/255, alpha: 1)
        }
    }
}
