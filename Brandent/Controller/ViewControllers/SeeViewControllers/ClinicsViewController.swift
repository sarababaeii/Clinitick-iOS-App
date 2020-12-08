//
//  ClinicsViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class ClinicsViewController: UIViewController {
    
    @IBOutlet weak var clinicsTableView: UITableView!
    
    var clinicsTableViewDelegate: ClinicsTableViewDelegate?
    
    func setDelegates() {
        clinicsTableViewDelegate = ClinicsTableViewDelegate()
        clinicsTableView.delegate = clinicsTableViewDelegate
        clinicsTableView.dataSource = clinicsTableViewDelegate
    }
    
    func configure() {
        setDelegates()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "مطب‌ها", style: UIBarButtonItem.Style.plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 22.0)!], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configure()
    }
}
