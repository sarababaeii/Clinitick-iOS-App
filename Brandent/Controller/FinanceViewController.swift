//
//  SecondViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import UIKit

class FinanceViewController: UIViewController {

    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var appointmentsIncomeLabel: UILabel!
    @IBOutlet weak var otherIncomeLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    
    var numberLabels = [UILabel]()
    var numbers = [String]()
    var isHidden = false
    
    @IBAction func changeNumbersVisiblity(_ sender: Any) {
        if isHidden {
            showNumbers()
        } else {
            hideNumbers()
        }
        isHidden = !isHidden
    }
    
    func hideNumbers() {
        for label in numberLabels {
            label.text = "******"
        }
    }
    
    func showNumbers() {
        for label in numberLabels {
            label.text = numbers[label.tag]
        }
    }
    
    func configure() {
        numberLabels = [totalIncomeLabel, appointmentsIncomeLabel, otherIncomeLabel, expensesLabel]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Info.sharedInstance.lastViewController = self
    }
}
