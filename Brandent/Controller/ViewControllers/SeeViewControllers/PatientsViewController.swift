//
//  PatientsViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 10/28/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class PatientsViewController: UIViewController {
    
    @IBOutlet weak var patientsTableView: UITableView!
    
    var patientsTableViewDelegate: PatientsTableViewDelegate?
    
    let testPatients = [Patient]()
    
    //MARK: Showing NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        configure()
    }
    
    override func viewWillLayoutSubviews() {
//        configure()
    }
    
    func configure() {
        setDelegates()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "لیست بیماران", style: UIBarButtonItem.Style.plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 22.0)!], for: .normal)
    }
    
    func setDelegates() {
        patientsTableViewDelegate = PatientsTableViewDelegate(tableView: patientsTableView)
        patientsTableView.delegate = patientsTableViewDelegate
        patientsTableView.dataSource = patientsTableViewDelegate
    }
    
    //MARK: Sending Sender to PatientProfile
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeePatientHistorySegue",
            let cell = sender as? PatientTableViewCell,
            let patient = cell.patient,
            let viewController = segue.destination as? PatientProfileViewController {
                viewController.patient = patient
        }
    }
}
