//
//  NSMutableData.swift
//  Brandent
//
//  Created by Sara Babaei on 11/16/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
