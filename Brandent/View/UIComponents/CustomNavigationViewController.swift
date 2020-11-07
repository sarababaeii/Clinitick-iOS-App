//
//  CustomNavigationViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 11/6/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class CustomNavigationBar: UINavigationBar {
    
    @IBInspectable var height: CGFloat = 72 {
        didSet {
            self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: height)
            print(self.frame.size.height)
        }
    }
}
