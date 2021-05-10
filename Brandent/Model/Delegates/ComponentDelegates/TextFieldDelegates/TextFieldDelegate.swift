//
//  TextFieldDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 12/16/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var viewController: UIResponder
    
    //MARK: Initialization
    init(viewController: UIResponder) {
        self.viewController = viewController
    }
    
    //MARK: Begin Editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let viewController = viewController as? FormViewController {
            viewController.currentTextField = textField
        }
        else if let tableViewCell = viewController as? AddAppointmentTableViewCell {
            tableViewCell.currentTextField = textField
        }
    }
    
    //MARK: Change Editing
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        if isForDate {
//            if let viewController = viewController as? FormViewController {
//                viewController.date = nil
//            }
//            else if let tableViewCell = viewController as? AddAppointmentTableViewCell {
//                tableViewCell.date = nil
//            }
//            return true
//        }
//        if isForTooth {
//            if let viewController = viewController as? FormViewController {
//                viewController.data[textField.tag] = ""
//            }
//            else if let tableViewCell = viewController as? AddAppointmentTableViewCell {
//                tableViewCell.data[textField.tag] = ""
//            }
//            return true
//        }
//        return false
//    }
    
    //MARK: End Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        getTextData(textField)
    }
    
    //MARK: Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let viewController = viewController as? FormViewController {
            if viewController.textFields.count > textField.tag + 1 {
                viewController.textFields[textField.tag + 1].becomeFirstResponder()
            }
        }
        else if let tableViewCell = viewController as? AddAppointmentTableViewCell {
            if tableViewCell.textFields.count > textField.tag + 1 {
                tableViewCell.textFields[textField.tag + 1].becomeFirstResponder()
            }
        }
        return true
    }
    
    func getTextData(_ textField: UITextField) {
        if let viewController = viewController as? FormViewController {
            if let text = textField.fetchInput() {
                viewController.data[textField.tag] = text
            } else {
                viewController.data[textField.tag] = ""
            }
        }
        else if let tableViewCell = viewController as? AddAppointmentTableViewCell {
            if let text = textField.fetchInput() {
                tableViewCell.data[textField.tag] = text
            } else {
                tableViewCell.data[textField.tag] = ""
            }
        }
    }
}
