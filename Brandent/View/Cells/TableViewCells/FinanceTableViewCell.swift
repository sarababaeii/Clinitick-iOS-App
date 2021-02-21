//
//  FinanceTableViewCell.swift
//  Brandent
//
//  Created by Sara Babaei on 11/3/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class FinanceTableViewCell: UITableViewCell {
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var diseaseLabel: UILabel! //just for appointments
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tomanLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var entity: Entity?
    
    func setAttributes(item: Entity) {
        self.entity = item
        if let finance = item as? Finance {
            setFinanceAttributes(finance: finance)
        }
        else if let appointment = item as? Appointment {
            setAppointmentAttributes(appointment: appointment)
        }
    }
    
    func setFinanceAttributes(finance: Finance) {
        nameLabel.text = finance.title
        diseaseLabel.isHidden = true
        setPriceLabel(price: finance.amount)
        if finance.is_cost {
            priceLabel.textColor = Color.red.componentColor
            tomanLabel.textColor = Color.red.componentColor
        }
        dateLabel.text = finance.date.toPersianShortString()  
    }
    
    func setAppointmentAttributes(appointment: Appointment) {
        nameLabel.text = appointment.patient.name
        diseaseLabel.text = appointment.disease.title
        setPriceLabel(price: appointment.price)
        dateLabel.text = appointment.visit_time.toPersianShortString()
    }
    
    func setPriceLabel(price: NSDecimalNumber) {
        if let price = price as? Int {
            priceLabel.text = (String.toPersianPriceString(price: price))
        }
    }
}
