//
//  MonthMenuDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 3/13/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation

class MonthMenuDelegate: DateMenuDelegate {
    
    override init(viewController: SeeFinanceViewController) {
        super.init(viewController: viewController)
    }
    
    //MARK: Collecting Options
    override func prepareMenu(menu: SwiftyMenu) {
        let options = ["فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور", "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"]
        setMenuDelegates(menu: menu, options: options)
    }
        
    //MARK: Delegate Function
    override func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
        viewController.setDate(yearNumber: nil, monthNumber: index + 1)
        viewController.financeTableViewDelegate?.date = viewController.date //didSet
    }
    
    override func didUnselectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
    }
}
