//
//  TextViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 10/16/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class TextViewDelegate: NSObject, UITextViewDelegate {
    let maxLength = 10
//    var textView: CustomTextView
    var characterLimitLabel: UILabel
    
    init(textView: CustomTextView, label: UILabel) {
//        self.textView = textView
        characterLimitLabel = label
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < maxLength    // 10 Limit Value
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        guard let text = textView.fetchInput() else {
            return
        }
        let remain = calculateRemainigCharacters(string: text)
        if remain <= 20 {
            setWordLimit(amount: remain)
        } else {
            characterLimitLabel.isHidden = true
        }
    }
    
    func calculateRemainigCharacters(string: String) -> Int {
        return maxLength - string.count
    }
    
    func setWordLimit(amount: Int) {
        let amountString = String(amount).convertEnglishNumToPersianNum()
        characterLimitLabel.text = "+\(amountString)"
        characterLimitLabel.isHidden = false
    }
    
    
}
