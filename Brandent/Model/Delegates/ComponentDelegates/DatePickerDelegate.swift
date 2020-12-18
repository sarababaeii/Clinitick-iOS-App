//
//  DatePickerDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 12/18/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class DatePickerDelegate {
    
    let datePicker = UIDatePicker()
    
    var viewController: FormViewController
    var textField: UITextField
    
    init(viewController: FormViewController, textField: UITextField) {
        self.viewController = viewController
        self.textField = textField
    }
    
}
