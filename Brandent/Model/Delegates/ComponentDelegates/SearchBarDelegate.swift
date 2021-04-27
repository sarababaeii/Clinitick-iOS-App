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
    
    var preSearchText = ""
    
    init(tableView: UITableView, tableViewDelegate: PatientsTableViewDelegate) {
        self.tableView = tableView
        self.tableViewDelegate = tableViewDelegate
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count < preSearchText.count {
            tableViewDelegate.updateItems()
        }
        if searchText != "" {
            let patients = tableViewDelegate.items as! [Patient]
            tableViewDelegate.items = patients.filter({$0.name.prefix(searchText.count) == searchText})
        }
        tableView.reloadData()
        preSearchText = searchText
    }
    
    func searchTextCleared(searchText: String) {
        tableViewDelegate.updateItems()
        tableView.reloadData()
        preSearchText = ""
    }
    
    func searchTextChanged(searchText: String) {
        if searchText.count < preSearchText.count {
            tableViewDelegate.updateItems()
        }
        let patients = tableViewDelegate.items as! [Patient]
        tableViewDelegate.items = patients.filter({$0.name.prefix(searchText.count) == searchText})
        tableView.reloadData()
        preSearchText = searchText
    }
}
