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
        print("IM HERE")
//        if let cell = sender as? UITableViewCell {
//            print("GOT CELL")
//        }
        if segue.identifier == "SeePatientHistorySegue" {
            print("SEGUE IS OKAY")
            print(sender)
            if let cell = sender as? PatientTableViewCell {
                print("SENDER CELL IS OK")
                if let patient = cell.patient {
                    print("SENDER PATIENT IS OK")
                    if let viewController = segue.destination as? PatientProfileViewController {
                        print("I SAT PATIENT")
                        viewController.patient = patient
                    }
                }
            }
        }
//        if segue.identifier == "SeePatientHistorySegue",
//            let cell = sender as? PatientTableViewCell,
//            let patient = cell.patient,
//            let viewController = segue.destination as? PatientProfileViewController {
//            print("I SAT PATIENT")
//            viewController.patient = patient
//        }
    }
    
    func setDelegates() {
        patientsTableViewDelegate = PatientsTableViewDelegate()
        patientsTableView.delegate = patientsTableViewDelegate
        patientsTableView.dataSource = patientsTableViewDelegate
    }
    
    func configure() {
//        Info.sharedInstance.lastViewController = self
        setDelegates()
    }
    
    override func viewWillLayoutSubviews() {
        configure()
    }
}
