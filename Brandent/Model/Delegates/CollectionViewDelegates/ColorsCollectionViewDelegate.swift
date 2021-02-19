//
//  ColorsCollectionViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 11/2/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ColorsCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var colors: [Color]
    var selectedColorCell: ColorCollectionViewCell?
    var selectedColor = Color.lightGreen
    
    //MARK: Initializer
    init(colors: [Color], selectedColor: Color) {
        self.colors = colors
        self.selectedColor = selectedColor
    }
    
    //MARK: Protocol Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCellID", for: indexPath) as! ColorCollectionViewCell
        if let color = colorDataSource(indexPath: indexPath) {
            cell.setAttributes(color: color, delegate: self)
        }
        return cell
    }
    
    func colorDataSource(indexPath: IndexPath) -> Color? {
        return colors[indexPath.row]
    }
}
