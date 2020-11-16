//
//  Image.swift
//  Brandent
//
//  Created by Sara Babaei on 11/16/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class Image {
    var name: String
    var data: Data
    
    init(img: Data) {
        self.data = img
        name = UUID().uuidString
    }
}
