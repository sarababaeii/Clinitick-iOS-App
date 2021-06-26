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
    @IBOutlet weak var noVisitLabel: UILabel!
    @IBOutlet weak var todayTasksTableView: UITableView!
    @IBOutlet weak var noNearTaskLabel: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var diseaseLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var todayTasksTableViewDelegate: TodayTasksTableViewDelegate?
    var menuCollectionViewDelegate: MenuCollectionViewDelegate?
    var blogPosts = [BlogPost]()
    
    //MARK: Initialization
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loadConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearConfigure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        Info.sharedInstance.sync()
        print("Dentist: \(String(describing: Info.sharedInstance.dentist))")
    }
    
    func loadConfigure() {
        setMenuDelegates()
        setBlogPosts()
    }
    
    func appearConfigure() {
        setTodayTasksDelegates()
        setUIComponents()
    }
    
    //MARK: Delegates
    func setMenuDelegates() {
        DispatchQueue.main.async {
            self.menuCollectionViewDelegate = MenuCollectionViewDelegate(viewController: self, items: self.blogPosts)
            self.menuCollectionView.delegate = self.menuCollectionViewDelegate
            self.menuCollectionView.dataSource = self.menuCollectionViewDelegate
        }
    }
    
    func setTodayTasksDelegates() {
        todayTasksTableViewDelegate = TodayTasksTableViewDelegate(noTaskLabel: noVisitLabel)
        todayTasksTableView.delegate = todayTasksTableViewDelegate
        todayTasksTableView.dataSource = todayTasksTableViewDelegate
    }
    
    //MARK: Blog
    func setBlogPosts() {
        RestAPIManagr.sharedInstance.getBlogPosts({(postsData) in
            if let data = postsData {
                BlogPost.getPostsArray(postsData: data, {(results) in
                    if let result = results {
                        self.blogPosts = result
                        self.setMenuDelegates()
                    }
                })
            }
        })
    }
 
    //MARK: UI Management
    func setUIComponents() {
        setHeaderView()
        setNextAppointmentView()
    }
    
    func setHeaderView() {
        dateLabel.text = Date().toPersianWeekDMonth()
        guard let dentist = Info.sharedInstance.dentist else {
            return
        }
        if let image = dentist.photo {
            profileImageView.image = UIImage(data: image)
        }
        dentistNameLabel.text = dentist.last_name
    }
    
    func setNextAppointmentView() {
        if let appointment = Info.sharedInstance.dataController?.getNextAppointment() {
            noNearTaskLabel.isHidden = true
            patientNameLabel.text = appointment.patient.name
            diseaseLabel.text = appointment.disease
            timeLabel.text = appointment.visit_time.toPersianTimeString()
        } else {
            noNearTaskLabel.isHidden = false
            patientNameLabel.text = ""
            diseaseLabel.text = ""
            timeLabel.text = ""
        }
    }
    
    //MARK: Sending Post URL to WebViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeBlogPostSegue",
            let cell = sender as? MenuCollectionViewCell,
            let post = cell.item,
            let viewController = segue.destination as? WebViewController {
            viewController.urlString = post.link
        }
    }
}
