//
//  ClinicsViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ClinicsViewController: UIViewController {
    
    @IBOutlet weak var clinicsTableView: UITableView!
    
    var clinicsTableViewDelegate: ClinicsTableViewDelegate?
    
    //MARK: Showing NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        configure()
    }
    
    func configure() {
        setDelegates()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "مطب‌ها", style: UIBarButtonItem.Style.plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 22.0)!], for: .normal)
    }
    
    func setDelegates() {
        clinicsTableViewDelegate = ClinicsTableViewDelegate(viewController: self, tableView: clinicsTableView)
        clinicsTableView.delegate = clinicsTableViewDelegate
        clinicsTableView.dataSource = clinicsTableViewDelegate
    }
}
