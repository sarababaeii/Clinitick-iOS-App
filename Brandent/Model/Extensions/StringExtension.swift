//
//  StringExtension.swift
//  Brandent
//
//  Created by Sara Babaei on 10/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
extension String {
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)), upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
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
    
    static func toPersianPriceString(price: Int) -> String {
        return String(price).convertEnglishNumToPersianNum().toPriceString(separator: ".")
    }
    
    func toPriceString(separator: String) -> String {
        let st = self.firstDotIndex()
        var ans = self[0 ..< st]
        for i in st ..< self.count {
            if (i - st) % 3 == 0 {
                ans += separator
            }
            ans += self[i]
        }
        return ans
    }
    
    func firstDotIndex() -> Int {
        switch self.count % 3 {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 0
        }
    }
    
}
