//
//  ImageViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 3/15/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: Image?
    
    override func viewDidAppear(_ animated: Bool) {
        imageView.image = image?.getRealImage()
    }
}
