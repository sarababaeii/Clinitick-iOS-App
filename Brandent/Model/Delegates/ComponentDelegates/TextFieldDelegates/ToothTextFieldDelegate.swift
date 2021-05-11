//
//  ToothTextFieldDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 5/10/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ToothTextFieldDelegate: TextFieldDelegate {
    
    //MARK: Initialization
    override init(viewController: UIResponder) { //FormViewController or AddAppointmentTableViewCell
        super.init(viewController: viewController)
    }

    //MARK: End Editing
    override func textFieldDidEndEditing(_ textField: UITextField) {
        return
    }
    
//    //MARK: Clear
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        if let viewController = viewController as? FormViewController {
//            viewController.data[textField.tag] = ""
//        }
//        else if let tableViewCell = viewController as? AddAppointmentTableViewCell {
//            tableViewCell.data[textField.tag] = ""
//        }
//        return true
//    }
}
