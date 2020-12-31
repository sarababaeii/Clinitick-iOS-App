//
//  AddViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddAppointmentViewController: UITableViewController {
    
    var patient: Patient?
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "AddAppointmentCellID", for: indexPath)
////        print("\(indexPath): \(cell.subviews)")
//        return cell
//    }
    
    //MARK: Showing NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        setTitle()
        print(tableView!.numberOfSections)
        var ip = IndexPath(row: 0, section: 0)
        
    }
    
    func getCellInformation(indexPath: IndexPath) -> Any? {
        let cell = tableView.cellForRow(at: indexPath)
        let textField = cell?.contentView.subviews[0] as? CustomTextField
        return textField?.fetchInput()
    }
    
    func getAppointmentInformation() {
        
    }
    
    @IBAction func submit(_ sender: Any) {
        for i in 0 ..< 2 {
            var ip = IndexPath(row: i, section: 0)
            print(getCellInformation(indexPath: ip))
        }
    }
    
    //MARK: UI Management
    func setTitle() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "فعالیت درمانی", style: UIBarButtonItem.Style.plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 22.0)!], for: .normal)
    }
}
