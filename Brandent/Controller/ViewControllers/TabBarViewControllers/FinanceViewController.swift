//
//  SecondViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class FinanceViewController: UIViewController {

    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var appointmentsIncomeLabel: UILabel!
    @IBOutlet weak var otherIncomeLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    
    var numberLabels = [UILabel]()
    var numbers = [36000000, 30000000, 10000000, 4000000]
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
            label.text = String.toPersianPriceString(price: numbers[label.tag])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeFinanceSegue",
            let gesture = sender as? UITapGestureRecognizer,
            let view = gesture.view,
            let viewController = segue.destination as? SeeFinanceViewController {
            viewController.senderTag = view.tag
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

//TODO: get numbers
