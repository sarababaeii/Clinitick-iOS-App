//
//  CustomTextField.swift
//  Brandent
//
//  Created by Sara Babaei on 9/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomTextField: UITextField {
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
    
    @IBInspectable var iconImage: UIImage? {
        didSet {
            setLeftIcon()
        }
    }
    
    @IBInspectable var iconPadding: CGFloat = 0 {
        didSet {
            if let _ = iconImage {
                setLeftIcon()
            }
        }
    }
    
    func setLeftIcon() {
        guard let icon = iconImage else {
            return
        }
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: icon.size.width + iconPadding, height: icon.size.height) )
        let iconView  = UIImageView(frame: CGRect(x: iconPadding, y: 0, width: icon.size.width, height: icon.size.height))
       
        iconView.image = icon
        outerView.addSubview(iconView)

        leftView = outerView
        leftViewMode = .always
  }
}

extension UITextField {
    func fetchInput() -> String? {
        if let caption = self.text?.trimmingCharacters(in: .whitespaces) {
            return caption.count > 0 ? caption : nil
        }
        return nil
    }
}
