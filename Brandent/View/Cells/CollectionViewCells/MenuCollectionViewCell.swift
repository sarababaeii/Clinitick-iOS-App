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
   
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var colorView: CustomUIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setAttributes(item: MenuItem) {
        iconImageView.image = item.image
        colorView.backgroundColor = item.color.menuItemColor
        titleLabel.text = item.title
    }
}
