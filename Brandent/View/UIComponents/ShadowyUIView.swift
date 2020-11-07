//
//  ShadowyUIView.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class ShadowyUIView: LightningUIView {
    
    @IBInspectable var shadowColor: UIColor = UIColor.white {
        didSet {
            self.layer.shadowColor = self.shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowAlpha: Float = 1 {
        didSet {
            self.layer.shadowOpacity = self.shadowAlpha
        }
    }
    
    @IBInspectable var shadowSize: CGSize = .zero {
        didSet {
            self.layer.shadowOffset = self.shadowSize
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = self.shadowBlur
        }
    }
    
    @IBInspectable var maskToBounds: Bool = false {
        didSet {
            self.layer.masksToBounds = self.maskToBounds
        }
    }
}
