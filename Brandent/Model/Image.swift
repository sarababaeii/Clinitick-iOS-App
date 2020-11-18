//
//  Image.swift
//  Brandent
//
//  Created by Sara Babaei on 11/16/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class Image: Equatable {
    var name: String
    var data: Data
    var img: UIImage
    
    init(img: Data) {
        self.name = UUID().uuidString
        self.data = img
        self.img = UIImage(data: data)!
    }
    
    init(img: UIImage) {
        self.name = UUID().uuidString
        self.data = img.jpegData(compressionQuality: 1)!
        self.img = img
    }
    
    static func == (lhs: Image, rhs: Image) -> Bool {
        return lhs.name == rhs.name
    }
}
