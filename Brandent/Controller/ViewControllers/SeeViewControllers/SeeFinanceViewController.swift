//
//  SeeFinanceViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import SwiftyMenu

@available(iOS 13.0, *)
class SeeFinanceViewController: UIViewController, SwiftyMenuDelegate {
    
    @IBOutlet weak var dateMenu: SwiftyMenu!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var tomanLabel: UILabel!
    @IBOutlet weak var financeTableView: UITableView!
    
    var senderTag = 0
    var date = Date()
    var financeTableViewDelegate: FinanceTableViewDelegate?
    let dateOptions = ["فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور", "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"]
    let titles = ["درآمد خالص", "ویزیت‌ها", "درآمدهای خارجی", "خرج‌ها"]
    
    //MARK: UI Management
    func setTitle() {
        self.title = titles[senderTag]
    }
    
    func setTotalAmount(totalAmount: Int) {
        var sum = totalAmount
        if sum < 0 {
            sum *= -1
            setTotalLabelColor(color: .red)
        } else {
            setTotalLabelColor(color: .green)
        }
        totalAmountLabel.text = String.toPersianPriceString(price: sum)
    }
    
    func setTotalLabelColor(color: Color) {
        totalAmountLabel.textColor = color.componentColor
        tomanLabel.textColor = color.componentColor
    }
    
    //MARK: DateMenu Functions
    func setDateMenuDelegates() {
        dateMenu.delegate = self
        dateMenu.options = dateOptions
        dateMenu.placeHolderText = date.toPersianMonthString()
//        dateMenu.expandingAnimationStyle = .linear
        dateMenu.collapsingAnimationStyle = .spring(level: .low)
    }
    
    func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
        print("^^ Selected option: \(selectedOption), at index: \(index)")
        setDate(monthNumber: index)
        setTableViewDelegates()
    }
    
    func setDate(monthNumber: Int) {
        let dateString = "1399-\(monthNumber + 1)-01"
        date = Date.getDate(date: dateString)!
        print(date)
    }
    
    //MARK: TableView Functions
    func setTableViewDelegates() {
        guard let finances = Finance.getFinancesArray(tag: senderTag, date: date) else {
            return
        }
        setTotalAmount(totalAmount: Finance.calculateSum(finances: finances))
        financeTableViewDelegate = FinanceTableViewDelegate(finances: finances)
        financeTableView.delegate = financeTableViewDelegate
        financeTableView.dataSource = financeTableViewDelegate
    }
    
    func setDelegates() {
        setTableViewDelegates()
        setDateMenuDelegates()
    }
    
    func configure() {
        setTitle()
        setDelegates()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
}
