//
//  FinanceTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 11/6/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FinanceTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
   
    var finances = [NSManagedObject]()
    
    //MARK: Initializer
    init(finances: [Any]) {
        if let finances = finances as? [NSManagedObject] {
            self.finances = finances
        }
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceCellID", for: indexPath) as! FinanceTableViewCell
        if let finance = financeDataSource(indexPath: indexPath) {
            cell.setAttributes(item: finance)
        }
        return cell
    }
    
    func financeDataSource(indexPath: IndexPath) -> Any? {
        if indexPath.row < finances.count {
            return finances[finances.count - indexPath.row - 1]
        }
        return nil
    }
}
