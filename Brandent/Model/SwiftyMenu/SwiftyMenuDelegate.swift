//
//  SwiftyMenuDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 2/26/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation

public protocol SwiftyMenuDelegate: NSObjectProtocol {
    func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int)
    func swiftyMenuWillAppear(_ swiftyMenu: SwiftyMenu)
    func swiftyMenuDidAppear(_ swiftyMenu: SwiftyMenu)
    func swiftyMenuWillDisappear(_ swiftyMenu: SwiftyMenu)
    func swiftyMenuDidDisappear(_ swiftyMenu: SwiftyMenu)
}

public extension SwiftyMenuDelegate {
    func swiftyMenuWillAppear(_ swiftyMenu: SwiftyMenu) { }
    
    func swiftyMenuDidAppear(_ swiftyMenu: SwiftyMenu) { }
    
    func swiftyMenuWillDisappear(_ swiftyMenu: SwiftyMenu) { }
    
    func swiftyMenuDidDisappear(_ swiftyMenu: SwiftyMenu) { }
}
