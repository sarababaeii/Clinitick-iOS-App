//
//  TodayTasks.swift
//  Brandent
//
//  Created by Sara Babaei on 11/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

class TodayTasks {
    var number: Int
    var clinic: Clinic?
    
    init(number: Int, clinic: Clinic?) {
        self.number = number
        self.clinic = clinic
    }
}
