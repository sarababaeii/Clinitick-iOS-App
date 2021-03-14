//
//  ClinicMenuDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 12/18/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class MenuDelegate: NSObject, SwiftyMenuDelegate {
    
    var viewController: UIViewController
    var menuDataIndex: Int
    
    init(viewController: UIViewController, menuDataIndex: Int) {
        self.viewController = viewController
        self.menuDataIndex = menuDataIndex
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
