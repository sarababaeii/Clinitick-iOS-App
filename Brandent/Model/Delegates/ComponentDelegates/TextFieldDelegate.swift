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
    var isForPrice: Bool
    var isForDate: Bool
    var isForAppointmetTitle: Bool
    
    
    //MARK: Initialization
    init(viewController: FormViewController, isForPrice: Bool, isForDate: Bool) {
        self.viewController = viewController
        self.isForPrice = isForPrice
        self.isForDate = isForDate
        self.isForAppointmetTitle = false
    }
    
     init(tableViewCell: AddAppointmentTableViewCell, isForPrice: Bool, isForDate: Bool, isForAppointmetTitle: Bool) {
        self.viewController = tableViewCell
        self.isForPrice = isForPrice
        self.isForDate = isForDate
        self.isForAppointmetTitle = isForAppointmetTitle
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
        if isForAppointmetTitle {
            enableOtherTextFields(state: true)
        }
        else if isForPrice {
            if let text = textField.text, text.count > 0 {
                textField.text = text.toPriceString(separator: ".", willAdd: string)
            }
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if isForDate {
            if let viewController = viewController as? FormViewController {
                viewController.date = nil
            }
            else if let tableViewCell = viewController as? AddAppointmentTableViewCell {
                tableViewCell.date = nil
            }
            return true
        }
        return false
    }
    
    //MARK: End Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isForDate {
            return
        }
        if isForPrice {
            getPriceData(textField)
        } else {
            getTextData(textField)
        }
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
    
    private func getPriceData(_ textField: UITextField) {
        if let viewController = viewController as? FormViewController {
            guard let text = textField.fetchInput(), let price = text.toPriceInt() else {
                viewController.data[textField.tag] = ""
                return
            }
            viewController.data[textField.tag] = price
        }
        else if let tableViewCell = viewController as? AddAppointmentTableViewCell {
            guard let text = textField.fetchInput(), let price = text.toPriceInt() else {
                tableViewCell.data[textField.tag] = ""
                return
            }
            tableViewCell.data[textField.tag] = price
        }
//        textField.text = "\(String.toPersianPriceString(price: price)) تومان"
    } //TODO: Persian numbers
    
    private func getTextData(_ textField: UITextField) {
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
                if isForAppointmetTitle {
                    enableOtherTextFields(state: true)
                }
            } else {
                tableViewCell.data[textField.tag] = ""
                enableOtherTextFields(state: false)
            }
        }
    }
    
    private func enableOtherTextFields(state: Bool) {
        if let tableViewCell = viewController as? AddAppointmentTableViewCell {
            tableViewCell.isFilled = state
            for i in 1 ..< 4 {
                tableViewCell.textFields[i].isEnabled = state
                if !state {
                    tableViewCell.textFields[i].text = ""
                    if i == 1 {
                        tableViewCell.data[i] = ""
                    } else {
                        tableViewCell.date = nil
                    }
                }
            }
        }
    }
}
