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
    @IBOutlet weak var todayTableView: UITableView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var diseaseLabel: UILabel!
    
    var menuCollectionViewDelegate: MenuCollectionViewDelegate?
    
    @IBAction func changeAppointmentState(_ sender: Any) {
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
//        patientNameLabel.text =
//        diseaseLabel.text = 
    }
    
    //MARK: Delegates
    func setDelegates() {
        setMenuDelegates()
        setTodayDelegates()
        setTextViewDelegates()
    }
    
    func setMenuDelegates() {
        menuCollectionViewDelegate = MenuCollectionViewDelegate()
        menuCollectionView.delegate = menuCollectionViewDelegate
        menuCollectionView.dataSource = menuCollectionViewDelegate
    }
    
    func setTodayDelegates() {
//        todayCollectionViewDelegate = TodayCollectionViewDelegate()
//        todayTableView.delegate = todayCollectionViewDelegate
//        todayTableView.dataSource = todayCollectionViewDelegate
    }
    
    func setTextViewDelegates() {
        quoteTextView.isEditable = true
        quoteTextView.text = "\"آینده از آن کسانی است که به استقبال آن می‌روند.\""
        quoteTextView.font = UIFont(name: "Vazir-Bold", size: 14)
        quoteTextView.isEditable = false
    }
    
    func configure() {
        setDelegates()
        setUIComponents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Info.sharedInstance.lastViewController = self
//        configure()
    }
}
