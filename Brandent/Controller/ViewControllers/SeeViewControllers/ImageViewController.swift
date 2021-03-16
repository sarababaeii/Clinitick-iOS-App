//
//  ImageViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 3/15/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: Image?
    
    override func viewDidLoad() {
        addGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imageView.image = image?.getRealImage()
        
    }
    
    func addGesture() {
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateImageView(_:)))
        rotationGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(rotationGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scaleImageView(_:)))
        pinchGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    @objc func rotateImageView(_ sender: UIRotationGestureRecognizer){
        guard let _ = image else {
            return
        }
        imageView.transform = imageView.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }

    @objc func scaleImageView(_ sender: UIPinchGestureRecognizer){
        guard let _ = image else {
            return
        }
        imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
}
