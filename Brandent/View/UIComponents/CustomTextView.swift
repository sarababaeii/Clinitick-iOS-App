//
//  CustomTextView.swift
//  Brandent
//
//  Created by Sara Babaei on 10/16/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomTextView: UITextView, UITextViewDelegate {
    let maxLength = 10
    
    @IBInspectable var sidePadding: CGFloat = 15 {
        didSet {
            
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        if let text = textView.text {
            print(text); //the textView parameter is the textView where text was changed
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < maxLength    // 10 Limit Value
    }
    
//    private var __maxLengths = [UITextField: Int]()
//
//    @IBInspectable var maxLength: Int {
//        get {
//            guard let l = __maxLengths[self] else {
//                return 150 // (global default-limit. or just, Int.max)
//            }
//            return l
//        }
//        set {
//            __maxLengths[self] = newValue
//            addTarget(self, action: #selector(fix), for: .editingChanged)
//        }
//    }
//
//    @objc func fix(textField: UITextField) {
//        if let t = textField.text {
//            textField.text = String(t.prefix(maxLength))
//        }
//    }
        
//    @IBInspectable var placeHolderColor: UIColor = UIColor(red: 202, green: 202, blue: 202, alpha: 1) {
//        didSet {
//            if let placeholder = self.placeholder {
//                self.setPlaceHolderColor(string: placeholder, color: self.placeHolderColor)
//            }
//        }
//    }
//    
//    func setPlaceHolderColor(string: String, color: UIColor) {
//        self.attributedPlaceholder = NSAttributedString(string: string, attributes:[NSAttributedString.Key.foregroundColor: color])
//    }
}

extension UITextView {
    func fetchInput() -> String? {
        if let caption = self.text?.trimmingCharacters(in: .whitespaces) {
            return caption.count > 0 ? caption : nil
        }
        return nil
    }
}
