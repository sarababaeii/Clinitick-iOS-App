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
    
    func setDelegates() {
        guard let patient = self.patient else {
            return
        }
        appointmentsTableViewDelegate = AppointmentsTableViewDelegate(patient: patient)
        appointmentsTableView.delegate = appointmentsTableViewDelegate
        appointmentsTableView.dataSource = appointmentsTableViewDelegate
    }
    
    func configure() {
        setDelegates()
    }
    
    override func viewWillLayoutSubviews() {
        configure()
    }
}
