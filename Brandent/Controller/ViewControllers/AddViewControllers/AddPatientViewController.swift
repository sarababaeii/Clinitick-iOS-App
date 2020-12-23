//
//  AddPatientViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 12/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import SwiftyMenu

class AddPatientViewController: FormViewController {
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var clinicMenu: SwiftyMenu!
    @IBOutlet weak var alergyMenu: SwiftyMenu!
    
    var textFieldDelegates = [TextFieldDelegate]()
    var menuDelegate: MenuDelegate?
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
//        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.tabBarController?.tabBar.isHidden = true
        configure()
    }
    
    func configure() {
        initializeTextFields()
        setMenuDelegate()
        setTitle(title: "اطلاعات بیمار")
    }
    
    func initializeTextFields() {
        textFields = [phoneNumberTextField, nameTextField]
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
    
    //MARK: Keyboard Management
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        getLastData()
        if let requiredItem = mustComplete() {
            submitionError(for: requiredItem)
            return
        }
        
        let patient = Patient.getPatient(id: nil, phone: data[0] as! String, name: data[1] as! String, alergies: (data[3] as! String))
        print(patient)
        nextPage(patient: patient)
    }
    
    override func mustComplete() -> Any? {
        for i in 0 ..< 3 { //alergy is optional
            if data[i] as? String == "" {
                return textFields[i]
            }
        }
        return nil
    }
    
    func nextPage(patient: Patient) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAppointmentViewController") as? AddAppointmentViewController else {
            return
        }
        controller.patient = patient
        navigationController?.show(controller, sender: nil)
    }
}

//TODO: Set alergy
