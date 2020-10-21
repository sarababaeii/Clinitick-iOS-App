//
//  CustomTabBar.swift
//  Brandent
//
//  Created by Sara Babaei on 10/19/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBar: UITabBar {
    @IBInspectable var rad: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = rad
        }
    }
}
