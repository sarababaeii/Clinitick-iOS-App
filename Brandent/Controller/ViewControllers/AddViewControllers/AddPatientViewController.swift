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
        navigationController?.setNavigationBarHidden(true, animated: animated)
//        self.tabBarController?.tabBar.isHidden = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
//        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
//        let play = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(playTapped))

//        navigationItem.rightBarButtonItems = [add, play]
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "بازگشت", style: UIBarButtonItem.Style.plain, target: self, action: .none)
//        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 14)!], for: .normal)
        configure()
    }
    
    @objc func addTapped() {
        print("add tapped")
    }
    
    @objc func playTapped() {
        print("play tapped")
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
        textFieldDelegates = [
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false),
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false)]
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
        if let clinic = getClinic() {
            print(clinic)
            nextPage(patient: patient, clinic: clinic)
        }
    }
    
    override func mustComplete() -> Any? {
        for i in 0 ..< 3 { //alergy is optional
            if data[i] as? String == "" {
                print(i)
                if i == 2 {
                    return clinicMenu
                }
                return textFields[i]
            }
        }
        return nil
    }
    
    func getClinic() -> Clinic? {
        return Clinic.getClinicByTitle(data[2] as! String)
    }
    
    func nextPage(patient: Patient, clinic: Clinic) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TempAddAppointmrntViewController") as? TempAddAppointmrntViewController else {
            return
        }
        controller.patient = patient
        controller.clinic = clinic
        navigationController?.show(controller, sender: nil)
    }
}

//TODO: Set alergy
