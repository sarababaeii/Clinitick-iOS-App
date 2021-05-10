//
//  PriceTextFieldDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 5/10/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class PriceTextFieldDelegate: TextFieldDelegate {
    
    //MARK: Initialization
    override init(viewController: UIResponder) { //FormViewController or AddAppointmentTableViewCell
        super.init(viewController: viewController)
    }
    
    //MARK: Change Editing
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, text.count > 0 {
            textField.text = text.toPriceString(separator: ".", willAdd: string)
        }
        return true
    }
    
    //MARK: End Editing
    override func textFieldDidEndEditing(_ textField: UITextField) {
        getPriceData(textField)
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
}
