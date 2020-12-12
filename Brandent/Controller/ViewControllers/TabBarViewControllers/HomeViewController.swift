//
//  FirstViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var profileImageView: CustomImageView!
    @IBOutlet weak var dentistNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var todayTasksTableView: UITableView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var diseaseLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var menuCollectionViewDelegate: MenuCollectionViewDelegate?
    var todayTasksTableViewDelegate: TodayTasksTableViewDelegate?
    
    //MARK: Functions
    func openPage(item: MenuItem) {
        if let viewControllers = tabBarController?.viewControllers {
            Info.sharedInstance.selectedMenuItem = item
            tabBarController?.selectedViewController = viewControllers[item.tabBarItemIndex]
        }
    }
    
    //MARK: UIComponents
    func setUIComponents() {
        setHeaderView()
        setQuoteView()
        setNextAppointmentView()
    }
    
    func setHeaderView() {
//        profileImageView.image =
//        dentistNameLabel.text =
        dateLabel.text = Date().toPersianWeekDMonth()
    }
    
    func setQuoteView() {
//        quoteTextView.text =
    }
    
    func setNextAppointmentView() {
        if let appointment = Info.dataController.getNextAppointment() {
            patientNameLabel.text = appointment.patient.name
            diseaseLabel.text = appointment.disease.title
            timeLabel.text = appointment.visit_time.toPersianTimeString()
        }
    }
    
    //MARK: Delegates
    func setMenuDelegates() {
        menuCollectionViewDelegate = MenuCollectionViewDelegate(viewController: self)
        menuCollectionView.delegate = menuCollectionViewDelegate
        menuCollectionView.dataSource = menuCollectionViewDelegate
    }
    
    func setTodayTasksDelegates() {
        todayTasksTableViewDelegate = TodayTasksTableViewDelegate()
        todayTasksTableView.delegate = todayTasksTableViewDelegate
        todayTasksTableView.dataSource = todayTasksTableViewDelegate
    }
    
    func setTextViewDelegates() {
        quoteTextView.isEditable = true
        quoteTextView.text = "\"آینده از آن کسانی است که به استقبال آن می‌روند.\""
        quoteTextView.font = UIFont(name: "Vazir-Bold", size: 14)
        quoteTextView.isEditable = false
    }
    
    func loadConfigure() {
        setMenuDelegates()
        setTextViewDelegates()
    }
    
    func appearConfigure() {
        setTodayTasksDelegates()
        setUIComponents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadConfigure()
        Info.sharedInstance.sync()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Info.sharedInstance.lastViewControllerIndex = TabBarItemIndex.home.rawValue
        appearConfigure()
    }
}
