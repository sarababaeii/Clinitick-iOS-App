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
    var compressedImg: UIImage
    var realImage: UIImage?
    
    init(img: Data) {
        self.name = UUID().uuidString
        self.data = img
        self.compressedImg = UIImage(data: data)!
    }
    
    init(name: String, urlString: String) {
        self.name = name
        guard let url = URL(string: "\(urlString)\(name)"), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
            self.compressedImg = UIImage(named: "gallery")!
            self.data = compressedImg.jpegData(compressionQuality: 1)!
            return
        }
        self.data = data
        self.compressedImg = image
    }
    
    init(img: UIImage) {
        self.name = UUID().uuidString
        self.data = img.jpegData(compressionQuality: 1)!
        self.compressedImg = img
    }
    
    static func == (lhs: Image, rhs: Image) -> Bool {
        return lhs.name == rhs.name
    }
    
    func getRealImage() -> UIImage? {
        if realImage != nil {
            return realImage!
        }
        guard let url = URL(string: "\(API.realImageFiles)\(name)"), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
            return nil
        }
        realImage = image
        return realImage
    }
}
