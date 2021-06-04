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
    
    @IBOutlet weak var patientSearchBar: UISearchBar!
    @IBOutlet weak var patientsTableView: UITableView!
    
    var patientsTableViewDelegate: PatientsTableViewDelegate?
    var searchBarDelegate: SearchBarDelegate?
    
    //MARK: Showing NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        configure()
    }
    
    func configure() {
        setDelegates()
        setSearchBarUI()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "لیست بیماران", style: UIBarButtonItem.Style.plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 22.0)!], for: .normal)
    }
    
    //MARK: UI Management
    func setSearchBarUI() {
        patientSearchBar.text = ""
        if #available(iOS 13, *) {
           patientSearchBar.searchTextField.font = UIFont(name: "Vazir-Bold", size: 14.0)
           patientSearchBar.searchTextField.textColor = UIColor.black
            patientSearchBar.searchTextField.backgroundColor = UIColor.white
        }
        patientSearchBar.searchBarStyle = .minimal
    }
    
    //MARK: Delegates
    func setDelegates() {
        setTableViewDelegates()
        setSearchBarDelegate()
    }
    
    func setTableViewDelegates() {
        patientsTableViewDelegate = PatientsTableViewDelegate(viewController: self, tableView: patientsTableView)
        patientsTableView.delegate = patientsTableViewDelegate
        patientsTableView.dataSource = patientsTableViewDelegate
    }
    
    func setSearchBarDelegate() {
        searchBarDelegate = SearchBarDelegate(tableView: patientsTableView, tableViewDelegate: patientsTableViewDelegate!)
        patientSearchBar.delegate = searchBarDelegate
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
