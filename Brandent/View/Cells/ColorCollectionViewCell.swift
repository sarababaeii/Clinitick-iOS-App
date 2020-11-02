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
    @IBOutlet weak var selectedView: CustomUIView!
    
    var color: Color = Color.lightGreen
    var delegate: ColorsCollectionViewDelegate?
    
    func setAttributes(color: Color, delegate: ColorsCollectionViewDelegate) {
        self.color = color
        self.delegate = delegate
        colorButton.backgroundColor = color.clinicColor
        
        if color == Color.lightGreen {
            selectColor()
        }
    }
    
    @IBAction func colorPicked(_ sender: Any) {
        delegate?.selectedColorCell?.unselectColor()
        selectColor()
    }
    
    func selectColor() {
        delegate?.selectedColorCell = self
        selectedView.isHidden = false
    }
    
    func unselectColor() {
        selectedView.isHidden = true
    }
}
