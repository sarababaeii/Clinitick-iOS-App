//
//  SeeFinanceViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
//import SwiftyMenu

class SeeFinanceViewController: UIViewController {
    
    @IBOutlet weak var monthMenu: SwiftyMenu!
    @IBOutlet weak var yearMenu: SwiftyMenu!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var tomanLabel: UILabel!
    @IBOutlet weak var financeTableView: UITableView!
    
    var date = Date() {
        didSet {
            financeTableViewDelegate?.date = date
        }
    }
    var monthMenuDelegate: MonthMenuDelegate?
    var yearMenuDelegate: YearMenuDelegate?
    var financeTableViewDelegate: FinanceTableViewDelegate?
    
    var senderTag = 0
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
        setMonthMenuDelegate()
        setYearMenuDelegate()
    }
    
    func setMonthMenuDelegate() {
        monthMenuDelegate = MonthMenuDelegate(viewController: self)
        monthMenuDelegate?.prepareMenu(menu: monthMenu)
        monthMenu.selectOption(option: date.toPersianMonthString())
    }
    
    func setYearMenuDelegate() {
        yearMenuDelegate = YearMenuDelegate(viewController: self)
        yearMenuDelegate?.prepareMenu(menu: yearMenu)
        yearMenu.selectOption(option: date.toPersianYearString())
    }
    
    func setDate(yearNumber:Int?, monthNumber: Int?) {
        let dateString = "\(yearNumber ?? date.componentsOfDate.year)-\((monthNumber ?? date.componentsOfDate.month))-01"
        date = Date.getPersianDate(from: dateString)!
    }
    
    //MARK: TableView Functions
    func setTableViewDelegates() {
        financeTableViewDelegate = FinanceTableViewDelegate(viewController: self, tableView: financeTableView, tag: senderTag)
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
