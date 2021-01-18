//
//  FirstViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import UIKit

class HomeViewController: TabBarViewController {

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
    
    //MARK: Initialization
    override func viewWillAppear(_ animated: Bool) {
        if let lastViewController = Info.sharedInstance.lastViewControllerIndex,
            let viewControllers = tabBarController?.viewControllers {
            tabBarController?.selectedViewController = viewControllers[lastViewController]
        }
        navigationController?.navigationBar.prefersLargeTitles = false
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configure()
    }
    
    func configure() {
        setTodayTasksDelegates()
        setUIComponents()
        setMenuDelegates()
        setTextViewDelegates()
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
    
    //MARK: UI Management
    func setUIComponents() {
        setHeaderView()
        setQuoteView()
        setNextAppointmentView()
    }
    
    func setHeaderView() {
        dateLabel.text = Date().toPersianWeekDMonth()
        guard let dentist = Info.sharedInstance.dentist else {
            return
        }
        
        if let image = Info.sharedInstance.dentistImage {
            profileImageView.image = image
        }
//        profileImageView.image = dentist.photo
        dentistNameLabel.text = dentist.last_name
    }
    
    func setQuoteView() {
//        quoteTextView.text =
    }
    
    func setNextAppointmentView() {
        if let appointment = DataController.sharedInstance.getNextAppointment() {
            patientNameLabel.text = appointment.patient.name
            diseaseLabel.text = appointment.disease.title
            timeLabel.text = appointment.visit_time.toPersianTimeString()
        }
    }
    
    //MARK: Item Navigations
    func openPage(item: MenuItem) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: item.viewControllerIdentifier)
        navigationController?.show(controller, sender: nil)
    }
}
