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
    
    //MARK: Showing NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        configure()
    }
    
    func configure() {
        setTitle()
        setDelegates()
    }
    
    func setDelegates() {
        setTableViewDelegates()
        setDateMenuDelegates()
    }
    
    //MARK: UI Management
    func setTitle() {
//        self.title = titles[senderTag]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: titles[senderTag], style: UIBarButtonItem.Style.plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 22.0)!], for: .normal)
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
        dateMenu.collapsingAnimationStyle = .spring(level: .low)
    }
    
    func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
        setDate(monthNumber: index)
        setTableViewDelegates()
    }
    
    func setDate(monthNumber: Int) {
        let dateString = "1399-\(monthNumber + 1)-01"
        date = Date.getPersianDate(from: dateString)!
    }
    
    //MARK: TableView Functions
    func setTableViewDelegates() {
        guard let finances = Finance.getFinancesArray(tag: senderTag, date: date) else {
            return
        }
        setTotalAmount(totalAmount: Finance.calculateSum(finances: finances))
        financeTableViewDelegate = FinanceTableViewDelegate(viewController: self, tableView: financeTableView, finances: finances)
        financeTableView.delegate = financeTableViewDelegate
        financeTableView.dataSource = financeTableViewDelegate
    }
    
    //MARK: Sending Sender to PatientProfile
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? FinanceTableViewCell, let entity = cell.entity else {
            return
        }
        if segue.identifier == "EditFinanceSegue",
            let finance = entity as? Finance,
            let viewController = segue.destination as? AddFinanceViewConrtoller {
                viewController.finance = finance
        }
        if segue.identifier == "EditAppointmentFromFinanceSegue",
            let appointment = entity as? Appointment,
            let viewController = segue.destination as? TempAddAppointmrntViewController {
                viewController.appointment = appointment
        }
    }
    
//    deinit {
//    }
}
