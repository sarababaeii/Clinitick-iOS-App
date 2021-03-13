//
//  DateMenuDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 3/13/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation

class DateMenuDelegate: NSObject, SwiftyMenuDelegate {
    
    var viewController: SeeFinanceViewController
    
    init(viewController: SeeFinanceViewController) {
        self.viewController = viewController
    }
    
    func prepareMenu(menu: SwiftyMenu) { //will be overriden in subclasses
    }
    
    func setMenuDelegates(menu: SwiftyMenu, options: [String]) {
        menu.delegate = self
        menu.options = options
        menu.collapsingAnimationStyle = .spring(level: .low)
    }
    
    //MARK: Delegate Function
    func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
    }
    
    func didUnselectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
    }
}
