//
//  SeeFinanceViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class SeeFinanceViewController: UIViewController {
    
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var financeTableView: UITableView!
    
    var senderTag = 0
    let datePicker = UIDatePicker()
    var date = Date()
    var financeTableViewDelegate: FinanceTableViewDelegate?
    let titles = ["درآمد خالص", "ویزیت‌ها", "درآمدهای خارجی", "خرج‌ها"]
    
    //MARK: UI Management
    func setTitle() {
        self.title = titles[senderTag]
    }
    
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
    func getFinancesArray() -> [Any]? {
        switch senderTag {
        case 0:
            return Info.dataController.fetchAllFinances(in: date)
        case 1:
            return Info.dataController.fetchAppointmentsInMonth(in: date)
        case 2:
            return Info.dataController.fetchFinanceExternalIncomes(in: date)
        case 3:
            return Info.dataController.fetchFinanceCosts(in: date)
        default:
            return Info.dataController.fetchAllFinances(in: date)
        }
    }
    
    func setDelegates() {
        guard let finances = getFinancesArray() else {
            return
        }
        financeTableViewDelegate = FinanceTableViewDelegate(finances: finances)
        financeTableView.delegate = financeTableViewDelegate
        financeTableView.dataSource = financeTableViewDelegate
    }
    
    func configure() {
        creatDatePicker()
        setTitle()
        setDelegates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
}

//TODO: set total and changing month
