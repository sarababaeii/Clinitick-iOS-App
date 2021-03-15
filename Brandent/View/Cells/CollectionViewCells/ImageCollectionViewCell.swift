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
    var image: Image?
    var imagesCollectionViewDelegate: ImagesCollectionViewDelegate?
    
    func setAttributes(image: Image, delegate: ImagesCollectionViewDelegate) {
        self.image = image
        imageView.image = image.compressedImg
        imagesCollectionViewDelegate = delegate
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        if let image = image {
            imagesCollectionViewDelegate?.deleteImage(image)
        }
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
}
