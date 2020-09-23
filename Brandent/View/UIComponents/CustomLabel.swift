//
//  CustomLabel.swift
//  Brandent
//
//  Created by Sara Babaei on 9/24/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomLabel: UILabel {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = 28
//            self.layer.cornerRadius = self.cornerRadius
        }
    }
}
