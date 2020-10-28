//
//  ImageCollectionViewCell.swift
//  Brandent
//
//  Created by Sara Babaei on 10/26/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var imagesCollectionViewDelegate: ImagesCollectionViewDelegate?
    
    func setAttributes(image: UIImage, delegate: ImagesCollectionViewDelegate) {
        imageView.image = image
        imagesCollectionViewDelegate = delegate
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        if let image = imageView.image {
            imagesCollectionViewDelegate?.deleteImage(image)
        }
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
}
