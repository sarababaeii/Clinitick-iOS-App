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
    
    @IBInspectable var placeholder: String? {
        didSet {
            self.text = placeholder
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = Color.gray.componentColor {
        didSet {
            self.textColor = placeholderColor
        }
    }
    
    @IBInspectable var sidePadding: CGFloat = 15 {
        didSet {
            self.textContainerInset = UIEdgeInsets(top: 15, left: sidePadding, bottom: 5, right: sidePadding)
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
}

extension UITextView {
    func fetchInput() -> String? {
        if self.textColor != Color.gray.componentColor,
            let caption = self.text?.trimmingCharacters(in: .whitespaces) {
            return caption.count > 0 ? caption : nil
        }
        return nil
    }
}
