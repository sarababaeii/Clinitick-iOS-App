//
//  MenuItem.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class MenuItem {
    var color: Color
    var image: UIImage
    var title: String
    var viewControllerIdentifier: String
    
    init(color: Color, image: UIImage, title: String, viewControllerIdentifier: String) {
        self.color = color
        self.image = image
        self.title = title
        self.viewControllerIdentifier = viewControllerIdentifier
    }
}
