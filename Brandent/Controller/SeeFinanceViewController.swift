//
//  SeeFinanceViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class SeeFinanceViewController: UIViewController {
    
    @IBOutlet weak var viewControllerTitleLabel: UILabel!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var financeTableView: UITableView!
    
    let datePicker = UIDatePicker()
    var date: Date?
    
    //MARK: DatePicker Functions
    func creatDatePicker() {
        datePicker.createPersianDatePicker()
        dateTextField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        dateTextField.inputAccessoryView = toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true )
    }
    
    @objc func donePressed() {
        dateTextField.text = datePicker.date.toCompletePersianString()
        dateTextField.endEditing(true)
        date = datePicker.date
    }
    
    //MARK: Initialization
        func setDelegates() {
        }
        
        func configure() {
            creatDatePicker()
            setDelegates()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
    //        configure()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            configure()
        }
    
}
