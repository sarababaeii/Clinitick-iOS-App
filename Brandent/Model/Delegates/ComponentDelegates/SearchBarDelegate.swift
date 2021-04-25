//
//  SearchBarDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 4/25/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class SearchBarDelegate: NSObject, UISearchBarDelegate {
   
    var tableView: UITableView
    var tableViewDelegate: PatientsTableViewDelegate
    
    init(tableView: UITableView, tableViewDelegate: PatientsTableViewDelegate) {
        self.tableView = tableView
        self.tableViewDelegate = tableViewDelegate
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            tableViewDelegate.updateItems()
            tableView.reloadData()
            return
        }
        let patients = tableViewDelegate.items as! [Patient]
        tableViewDelegate.items = patients.filter({$0.name.prefix(searchText.count) == searchText})
        tableView.reloadData()
    }
}
