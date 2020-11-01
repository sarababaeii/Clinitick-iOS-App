//
//  ColorCollectionViewCell.swift
//  Brandent
//
//  Created by Sara Babaei on 11/2/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorButton: UIButton!
    
    var color: Color = Color.lightGreen
    
    func setAttributes(color: Color) {
        self.color = color
        colorButton.backgroundColor = color.clinicColor
    }
    
    @IBAction func colorPicked(_ sender: Any) {
        
    }
}
