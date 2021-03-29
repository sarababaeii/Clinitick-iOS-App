//
//  AddAppointmentTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 3/24/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddAppointmentTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
   
    var appointmentCells = [AddAppointmentTableViewCell]()
    
    var viewController: AddAppointmentViewController
    
    //MARK: Initializer
    init(viewController: AddAppointmentViewController) {
        self.viewController = viewController
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddAppointmentCellID", for: indexPath) as! AddAppointmentTableViewCell
        cell.setAttributes(viewController: viewController)
        appointmentCells.append(cell)
        return cell
    }
    
    func submit() -> Bool {
        var numberOfAppointments = 0
        for i in 0 ..< appointmentCells.count {
            if appointmentCells[i].isFilled {
                if !appointmentCells[i].submit() {
                    return false
                }
                numberOfAppointments += 1
            }
        }
        if numberOfAppointments == 0 {
            return appointmentCells[0].submit()
        }
        return true
    }
}
