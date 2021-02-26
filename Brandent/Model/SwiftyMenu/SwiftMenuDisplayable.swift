//
//  SwiftMenuDisplayable.swift
//  Brandent
//
//  Created by Sara Babaei on 2/26/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation

// Markable interface for pathing datasource objects in late binding
public protocol SwiftMenuDisplayable {
    var displayValue: String { get }
    var valueToRetrive: Any { get }
}
