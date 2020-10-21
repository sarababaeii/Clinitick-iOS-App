//
//  CustmButton.swift
//  Brandent
//
//  Created by Sara Babaei on 9/19/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomButton: UIButton {
    @IBInspectable var titlePadding: CGFloat = 0 {
            didSet {
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: titlePadding, bottom: 0, right: titlePadding)
            }
        }
    
    @IBInspectable var imagePadding: CGFloat = 0 {
        didSet {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: imagePadding, bottom: 0, right: imagePadding)
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
