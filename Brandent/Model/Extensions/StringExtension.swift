//
//  StringExtension.swift
//  Brandent
//
//  Created by Sara Babaei on 10/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
extension String {
    func convertEnglishNumToPersianNum() -> String {
        let format = NumberFormatter()
        format.locale = Locale(identifier: "fa_IR")
        
        let number = format.number(from: self)
        let faNumber = format.string(from: number!)
        
        return faNumber!
    }
    
    func convertPersianNumToEnglishNum() -> String {
        let format = NumberFormatter()
        format.locale = Locale(identifier: "En")
        
        let number = format.number(from: self)
        let enNumber = format.string(from: number!)
        
        return enNumber!
    }
}
