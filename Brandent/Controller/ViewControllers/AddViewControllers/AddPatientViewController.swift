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

class AddPatientViewController: UIViewController, SwiftyMenuDelegate {
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var clinicMenu: SwiftyMenu!
    @IBOutlet weak var alergyMenu: SwiftyMenu!
    
    var clinicOptions = [String]()
    
    var textFields = [CustomTextField]()
    var currentTextField: UITextField?
    var paitentData = ["", "", "", ""] //0: phone, 1: name, 2: clinic, 3: alergy
    var clinicTitle: String?
    
    //MARK: UI Management
    func setTitle() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "اطلاعات بیمار", style: UIBarButtonItem.Style.plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 22.0)!], for: .normal)
    }
    
    //MARK: Clinic Functions
    func prepareClinicMenu() {
        getClinics()
        if clinicOptions.count > 0 {
            setClinicMenuDelegates()
        }
    }
    
    func getClinics() {
        clinicOptions.removeAll()
        if let clinics = Info.dataController.fetchAllClinics() as? [Clinic] {
            for clinic in clinics {
                clinicOptions.append(clinic.title)
            }
        }
    }
    
    func setClinicMenuDelegates() {
//        clinicMenu.isHidden = false
        clinicMenu.delegate = self
        clinicMenu.options = clinicOptions
        clinicMenu.collapsingAnimationStyle = .spring(level: .low)
    }
    
    func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
        paitentData[2] = selectedOption.displayValue
    }
    
    //MARK: TextFields Functions
    @IBAction func editingStarted(_ sender: Any) {
        if let textField = sender as? UITextField {
            currentTextField = textField
        }
    }
    
    @IBAction func editingEnded(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.fetchInput() {
            paitentData[textField.tag] = text
        }
    }
    
    //MARK: Keboard Management
    @IBAction func next(_ sender: Any) {
        if let textField = sender as? UITextField {
            textFields[textField.tag + 1].becomeFirstResponder()
        }
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        editingEnded(currentTextField as Any)
        currentTextField = nil
        
        if let requiredItem = mustComplete() {
            submitionError(for: requiredItem)
            return
        }
        
        let patient = Patient.getPatient(id: nil, phone: paitentData[0], name: paitentData[1], alergies: paitentData[3])
        nextPage(patient: patient)
    }
    
    func mustComplete() -> Any? {
        for i in 0 ..< 3 { //alergy is optional
            if paitentData[i] == "" {
                return textFields[i]
            }
        }
        return nil
    }
    
    func submitionError(for requiredItem: Any) {
        if let textField = requiredItem as? CustomTextField {
            textField.showError()
        }
        else if let menu = requiredItem as? SwiftyMenu {
            menu.showError()
        }
        self.showToast(message: "خطا: همه‌ی موارد ضروری وارد نشده است.")
    }
    
    func nextPage(patient: Patient) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAppointmentViewController") as? AddAppointmentViewController else {
            return
        }
        controller.patient = patient
        navigationController?.show(controller, sender: nil)
    }
    
    func configure() {
        textFields = [phoneNumberTextField, nameTextField]
        setTitle()
        prepareClinicMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configure()
    }
    
    //MARK: Showing NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
//        self.tabBarController?.tabBar.isHidden = true
        configure()
    }
}

//TODO: Set alergy
