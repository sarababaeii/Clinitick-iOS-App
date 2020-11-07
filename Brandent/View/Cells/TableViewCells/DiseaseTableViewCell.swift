//
//  DiseaseTableViewCell.swift
//  Brandent
//
//  Created by Sara Babaei on 10/28/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class DiseaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setAttributes(disease: Disease) {
        titleLabel.text = disease.title
        if let price = disease.price as? Int {
            priceLabel.text = String.toPersianPriceString(price: price)
        }
    }
}
