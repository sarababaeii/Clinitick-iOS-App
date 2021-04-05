//
//  AddAppointmentViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 3/22/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddAppointmentViewController: FormViewController {
    
    @IBOutlet weak var addAppointmentTableView: UITableView!
    
    var patient: Patient?
    var clinic: Clinic?
    
    var addAppointmentTableViewDelegate: AddAppointmentTableViewDelegate?
    var currentCell: AddAppointmentTableViewCell?
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        Info.sharedInstance.isForReturn = true
        setDelegates()
        setTitle(title: "فعالیت درمانی")
    }
    
    func setDelegates() {
        addAppointmentTableViewDelegate = AddAppointmentTableViewDelegate(viewController: self)
        addAppointmentTableView.delegate = addAppointmentTableViewDelegate
        addAppointmentTableView.dataSource = addAppointmentTableViewDelegate
    }
    
    //MARK: Keyboard Management
    @IBAction func hideKeyboard(_ sender: Any) {
        if let cell = currentCell, let textField = cell.currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        if let wasSuccessful = addAppointmentTableViewDelegate?.submit(), wasSuccessful {
            back()
        }
    }
    
    override func back() {
        navigateToPage(identifier: "TabBarViewController")
    }
}
