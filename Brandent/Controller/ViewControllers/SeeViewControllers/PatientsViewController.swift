//
//  PatientsViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 10/28/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class PatientsViewController: UIViewController {
    
    @IBOutlet weak var patientsTableView: UITableView!
    
    var patientsTableViewDelegate: PatientsTableViewDelegate?
    
    let testPatients = [Patient]()
    
    //MARK: Sending Sender to PatientProfile
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeePatientHistorySegue",
            let cell = sender as? PatientTableViewCell,
            let patient = cell.patient,
            let viewController = segue.destination as? PatientProfileViewController {
                viewController.patient = patient
        }
    }
    
    func setDelegates() {
        patientsTableViewDelegate = PatientsTableViewDelegate()
        patientsTableView.delegate = patientsTableViewDelegate
        patientsTableView.dataSource = patientsTableViewDelegate
    }
    
    func configure() {
//        Info.sharedInstance.lastViewController = self
        setDelegates()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "لیست بیماران", style: UIBarButtonItem.Style.plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 26.0)!], for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        configure()
    }
}
