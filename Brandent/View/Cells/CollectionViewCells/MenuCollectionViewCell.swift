//
//  MenuCollectionViewCell.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextView: UITextView!
    
    var item: BlogPost?
    
    func setAttributes(item: BlogPost) {
        self.item = item
        imageView.image = item.image
        titleTextView.text = item.title
    }
    @IBAction func goToPage(_ sender: Any) {
        item?.openPage()
    }
}
