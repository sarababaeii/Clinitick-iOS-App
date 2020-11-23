//
//  PatientProfileViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 11/3/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class PatientProfileViewController: UIViewController {
    
    @IBOutlet weak var appointmentsTableView: UITableView!
    
    var patient: Patient?
    
    var appointmentsTableViewDelegate: AppointmentsTableViewDelegate?
    
    func setHeader() {
//        self.title = patient?.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: patient?.name, style: UIBarButtonItem.Style.plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 26.0)!], for: .normal)
    }
    
    func setDelegates() {
        appointmentsTableViewDelegate = AppointmentsTableViewDelegate(patient: patient!)
        appointmentsTableView.delegate = appointmentsTableViewDelegate
        appointmentsTableView.dataSource = appointmentsTableViewDelegate
    }
    
    func configure() {
        if patient == nil {
            return
        }
        setHeader()
        setDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configure()
    }
}
