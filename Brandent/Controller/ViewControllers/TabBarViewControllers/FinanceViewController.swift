//
//  SecondViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import UIKit

class FinanceViewController: TabBarViewController {

    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var totalIncomeTomanLabel: UILabel!
    @IBOutlet weak var appointmentsIncomeTomanLabel: UILabel!
    @IBOutlet weak var appointmentsIncomeLabel: UILabel!
    @IBOutlet weak var otherIncomeLabel: UILabel!
    @IBOutlet weak var otherIncomeTomanLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var expensesTomanLabel: UILabel!
    
    var numberLabels = [UILabel]()
    var tomanLabels = [UILabel]()
    var numbers = [0, 0, 0, 0]
    var numbersAreHidden = false
    
    //MARK: Initialization
    override func viewDidAppear(_ animated: Bool) {
        configure()
    }
    
    func configure() {
//        self.setGradientSizes()
        initializeVariables()
        setNumbers()
        setNumberLabels()
    }
    
    func initializeVariables() {
        numberLabels = [totalIncomeLabel, appointmentsIncomeLabel, otherIncomeLabel, expensesLabel]
        tomanLabels = [totalIncomeTomanLabel, appointmentsIncomeTomanLabel, otherIncomeTomanLabel, expensesTomanLabel]
    }
    
    func setNumbers() {
        numbers[0] = 0
        for i in 1 ..< 4 {
            if let array = Finance.getFinancesArray(tag: i, date: Date()) {
                numbers[i] = Finance.calculateSum(finances: array)
                numbers[0] += numbers[i]
            }
        }
    }
    
    func setNumberLabels() {
        for i in 0 ..< 4 {
            if numbers[i] < 0 {
                numbers[i] *= -1
                setLabelColor(tag: i, color: .red)
            } else {
                setLabelColor(tag: i, color: .green)
            }
            numberLabels[i].text = String.toPersianPriceString(price: numbers[i])
        }
    }
    
    func setLabelColor(tag: Int, color: Color) {
        numberLabels[tag].textColor = color.componentColor
        tomanLabels[tag].textColor = color.componentColor
    }
    
    //MARK: Numbers Visibility
    @IBAction func changeNumbersVisiblity(_ sender: Any) {
        if numbersAreHidden {
            showNumbers()
        } else {
            hideNumbers()
        }
        numbersAreHidden = !numbersAreHidden
    }
    
    func hideNumbers() {
        for label in numberLabels {
            label.text = "******"
        }
    }
    
    func showNumbers() {
        for label in numberLabels {
            label.text = String.toPersianPriceString(price: numbers[label.tag])
        }
    }
    
    //MARK: Sending Data With Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeFinanceSegue",
            let gesture = sender as? UITapGestureRecognizer,
            let view = gesture.view,
            let viewController = segue.destination as? SeeFinanceViewController {
            viewController.senderTag = view.tag
        }
    }
}
