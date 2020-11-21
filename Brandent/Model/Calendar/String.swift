//
//  String.swift
//  Brandent
//
//  Created by Sara Babaei on 11/20/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

extension String{
    public var convertNumbers: String{
        var locale: Locale!
        if let localeString = UserDefaults.standard.object(forKey: "current_locale") as? String{
            locale = Locale(identifier: localeString)
        }else{
            locale = Locale.current
        }
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = locale
        
        var finalStr: String = ""
        for t in self{
            if let n = Int(String(t)){
                finalStr += formatter.string(from: NSNumber(integerLiteral: n))!
            }else{
                finalStr += String(t)
            }
        }
        return finalStr
    }
}
