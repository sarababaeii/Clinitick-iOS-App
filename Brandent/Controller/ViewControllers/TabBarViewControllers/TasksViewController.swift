//
//  TasksViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class TasksViewController: UIViewController {

    @IBOutlet weak var calendar: GDCalendar!
    @IBOutlet weak var line: LightningUIView!
    @IBOutlet weak var tasksTableView: UITableView!
    
    var taskTableViewDelegate: TasksTableViewDelegate?
    
    func setUIComponent() {
        // Initialize gradient layer.
        let gradientLayer: CAGradientLayer = CAGradientLayer()

        // Set frame of gradient layer.
        gradientLayer.frame = line.bounds

        // Color at the top of the gradient.
        let topColor: CGColor = line!.lightGradientColor.cgColor

        // Color at the bottom of the gradient.
        let bottomColor: CGColor = line!.darkGradientColor.cgColor

        // Set colors.
        gradientLayer.colors = [topColor, bottomColor]

        // Set start point.
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)

        // Set end point.
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        // Insert gradient layer into view's layer heirarchy.
        line.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func configure() {
        setUIComponent()
        UserDefaults.standard.set("fa_IR", forKey: "current_locale")
        calendar.dateSelectHandler = { [unowned self] date in
            self.taskTableViewDelegate?.date = date
        }
    }
    
    func setDelegates() {
        taskTableViewDelegate = TasksTableViewDelegate(tasksTableView: tasksTableView, date: Date())
        tasksTableView.delegate = taskTableViewDelegate
        tasksTableView.dataSource = taskTableViewDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Info.sharedInstance.lastViewControllerIndex = TabBarItemIndex.tasks.rawValue
        setDelegates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
}

//TODO: save changing state to DB
