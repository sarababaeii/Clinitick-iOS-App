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
        setTextViewDelegates()
    }
    
    func appearConfigure() {
        setTodayTasksDelegates()
        setUIComponents()
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
        if let image = dentist.photo {
            profileImageView.image = UIImage(data: image)
        }
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
        } else {
            patientNameLabel.text = ""
            diseaseLabel.text = ""
            timeLabel.text = ""
        }
    }
    
    //MARK: Item Navigations
    func openPage(item: MenuItem) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: item.viewControllerIdentifier)
        navigationController?.show(controller, sender: nil)
    }
}

/*
Optional("{
 \"finances\":[
     {\"is_cost\":\"true\",
     \"amount\":\"100000\",
     \"date\":\"2021-02-14\",
     \"title\":\"شام\",
     \"is_deleted\":\"false\",
     \"id\":\"833D1B17-87D8-496C-9AB3-A1AD98BE0EFD\"}
    ],
 \"clinics\":[],
 \"appointments\":[],
 \"tasks\":[],
 \"last_updated\":\"2021-02-14 11:45:25\",
 \"diseases\"[
    {
        \"title\":\"چک‌آپ\",
        \"price\":\"50000\",
        \"id\":\"E1D842E1-0184-4231-9316-9DB2EAEAEA68\"
    },
    {
        \"id\":\"8A99F076-8811-4558-BCF9-EBB6A4B98162\",
        \"price\":\"2000000\",
        \"title\":\"عصب کشی\"
    },
    {
        \"title\":\"جراحی لثه\",
        \"price\":\"1000000\",
        \"id\":\"DA71315B-DD19-4C48-82A2-25D5AE0867FB\"
    },
    {
        \"id\":\"AD29EBB0-41FB-4E2D-B887-BCC8BB9D2FCD\",
        \"price\":\"500000\",
        \"title\":\"ارتودنسی\"
    },
    {
        \"id\":\"FFE329DE-0B46-493E-A462-E03A278BB920\",
        \"title\":\"کرم\",
        \"price\":\"120000\"
    },
    {
        \"price\":\"70000\",
        \"title\":\"دندان درد\",
        \"id\":\"6101287C-8018-4CFB-814D-072FB7ED0209\"
    }
 ],
 \"patients\":[
    {\
        "phone\":\"09911245922\",\
        "full_name\":\"شایان بابایی\",
        \"id\":\"0E188788-9FB9-4DC8-9C69-042791551408\"
    },
    {
        \"id\":\"0E248C74-904A-4F48-928E-97D126D951DB\",
        \"full_name\":\"فرهاد بابایی\",
        \"phone\":\"09126099024\"
    }
 ]
}")
*/

/*
Optional("{
    \"message\":\"successful\",
    \"clinics\":[
        {
            \"id\":\"4182ca14-1a8c-4e4b-8d7e-c546c335b84e\",
            \"title\":\"کلینیک\",
            \"address\":\"\",
            \"color\":\"#00c0da\"
        },
        {
            \"id\":\"683c1911-c724-4921-b76e-129d15c0ea78\",
            \"title\":\"مطب\",
            \"address\":\"\",
            \"color\":\"#009989\"
        }
    ],
    \"finances\":[],
    \"patients\":[
        {
            \"id\":\"3594253c-de52-46fe-8661-3920ca117d89\",
            \"full_name\":\"فرهاد بابایی\",
            \"phone\":\"09190307668\"
        }
    ],
    \"appointments\":[],
    \"diseases\":[],
    \"tasks\":[],
    \"timestamp\":\"2021-02-14 13:37:54\"
}")
*/

/*
{
    appointments =     (
    );
    clinics =     (
                {
            address = "";
            color = "#00c0da";
            id = "4182ca14-1a8c-4e4b-8d7e-c546c335b84e";
            title = "\U06a9\U0644\U06cc\U0646\U06cc\U06a9";
        },
                {
            address = "";
            color = "#009989";
            id = "683c1911-c724-4921-b76e-129d15c0ea78";
            title = "\U0645\U0637\U0628";
        }
    );
    diseases =     (
    );
    finances =     (
    );
    message = successful;
    patients =     (
                {
            "full_name" = "\U0641\U0631\U0647\U0627\U062f \U0628\U0627\U0628\U0627\U06cc\U06cc";
            id = "3594253c-de52-46fe-8661-3920ca117d89";
            phone = 09190307668;
        }
    );
    tasks =     (
    );
    timestamp = "2021-02-14 13:37:54";
}
*/
