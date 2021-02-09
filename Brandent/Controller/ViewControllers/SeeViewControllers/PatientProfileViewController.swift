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
    @IBOutlet weak var clinicsTextField: CustomTextField!
    @IBOutlet weak var alergyMenu: SwiftyMenu!
    @IBOutlet weak var appointmentsTableView: UITableView!
    
    var patient: Patient?
    
    var textFieldDelegates = [TextFieldDelegate]()
//    var menuDelegate: MenuDelegate?
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
//        setMenuDelegate()
        setInformation()
        setTitle(title: patient.name)
        setTableViewDelegates()
    }
    
    func initializeTextFields() {
        textFields = [phoneTextField, nameTextField]
        data = [patient!.phone, patient!.name, patient!.alergies ?? ""] //0: phone, 1: name, 2: alergy
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
    
    //MARK: Set Information
    func setInformation() {
        phoneTextField.text = patient?.phone
        nameTextField.text = patient?.name
        setClinics()
        //set alergy
    }
    
    func setClinics() {
        guard let clinics = patient?.getClinics() else {
            return
        }
        clinicsTextField.text = getClinicsString(clinics: clinics)
//        menuDelegate = MenuDelegate(viewController: self, menuDataIndex: 2)
//        menuDelegate!.prepareClinicMenu(menu: clinicMenu)
    }
    
    func getClinicsString(clinics: [Clinic]) -> String {
        var str = ""
        for clinic in clinics {
            if str != "" {
                str += "، "
            }
            str += clinic.title
        }
        return str
    }
    
    func setTableViewDelegates() {
        appointmentsTableViewDelegate = AppointmentsTableViewDelegate(tableView: appointmentsTableView, patient: patient!)
        appointmentsTableView.delegate = appointmentsTableViewDelegate
        appointmentsTableView.dataSource = appointmentsTableViewDelegate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveData()
    }
    
    override func saveData() {
        getLastData()
        if isChanged() {
            patient?.updatePatient(phone: data[0] as? String, name: data[1] as? String, alergies: data[2] as? String)
        }
    }
    
    func isChanged() -> Bool {
        return (data[0] as? String != patient?.phone) ||
            (data[1] as? String != patient?.name) ||
            (data[2] as? String != patient?.alergies)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GallerySegue",
            let viewController = segue.destination as? GalleryViewController,
            let patient = patient {
            viewController.patient = patient
        }
    }
}
