//
//  Bool.swift
//  Brandent
//
//  Created by Sara Babaei on 11/28/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

extension Bool {
    static func intToBool(value: Int) -> Bool? {
        if value == 0 {
            return false
        }
        if value == 1 {
            return true
        }
        return nil
    }
}
