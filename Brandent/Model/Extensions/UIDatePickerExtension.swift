//
//  UIDatePickerExtension.swift
//  Brandent
//
//  Created by Sara Babaei on 11/4/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

extension UIDatePicker {
    func createPersianDatePicker(mode: UIDatePicker.Mode) {
        self.calendar = Calendar(identifier: .persian)
        self.locale = Locale(identifier: "fa_IR")
        self.datePickerMode = mode
        
        if #available(iOS 13.4, *) {
           self.preferredDatePickerStyle = .wheels
        } else {

        }
        
//        datePicker.setValue(UIFont(name: "Vazir", size: 20), forKeyPath: "textFont")
    }
}
