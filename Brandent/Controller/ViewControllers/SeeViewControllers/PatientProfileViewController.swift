//
//  PatientProfileViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 11/3/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import SwiftyMenu

class PatientProfileViewController: FormViewController {
    
    @IBOutlet weak var phoneTextField: CustomTextField!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var clinicMenu: SwiftyMenu!
    @IBOutlet weak var alergyMenu: SwiftyMenu!
    @IBOutlet weak var appointmentsTableView: UITableView!
    
    var patient: Patient?
    
    var textFieldDelegates = [TextFieldDelegate]()
    var menuDelegate: MenuDelegate?
    var appointmentsTableViewDelegate: AppointmentsTableViewDelegate?
    
    //MARK: Initialization
    override func viewDidLoad() {
        configure()
    }
    
    func configure() {
        guard let patient = patient else {
            return
        }
        initializeTextFields()
        setMenuDelegate()
        setInformation()
        setTitle(title: patient.name)
        setTableViewDelegates()
    }
    
    func setInformation() {
        phoneTextField.text = patient?.phone
        nameTextField.text = patient?.name
        //set clinic
        //set alergy
    }
    
    func initializeTextFields() {
        textFields = [phoneTextField, nameTextField]
        data = ["", "", "", ""] //0: phone, 1: name, 2: clinic, 3: alergy
        setTextFieldDelegates()
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false), TextFieldDelegate(viewController: self, isForPrice: false, isForDate: true)]
        for i in 0 ..< 2 {
            textFields[i].delegate = textFieldDelegates[i]
        }
    }
    
    func setMenuDelegate() {
        menuDelegate = MenuDelegate(viewController: self, menuDataIndex: 2)
        menuDelegate!.prepareClinicMenu(menu: clinicMenu)
    }
    
    func setTableViewDelegates() {
        appointmentsTableViewDelegate = AppointmentsTableViewDelegate(patient: patient!)
        appointmentsTableView.delegate = appointmentsTableViewDelegate
        appointmentsTableView.dataSource = appointmentsTableViewDelegate
    }
}
