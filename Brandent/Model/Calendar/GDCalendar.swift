//
//  GDCalendar.swift
//  Brandent
//
//  Created by Sara Babaei on 11/20/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public final class GDCalendar: UIView, UIGestureRecognizerDelegate{
    // Top view background color
    @IBInspectable
    public var headerBackgroundColor: UIColor = UIColor(red: 127 / 255, green: 124 / 255, blue: 118 / 255, alpha: 1.0)
    
    // Top view items text color
    @IBInspectable
    public var headerItemColor: UIColor = UIColor.white
    
    // Main calendar items text color
    @IBInspectable
    public var itemsColor: UIColor = UIColor.black
    
    // Selected day item background color
    @IBInspectable
    public var itemHighlightColor: UIColor = UIColor(red: 162 / 255, green: 0 / 255, blue: 10 / 255, alpha: 1.0)
    
    // Selected day item text color
    @IBInspectable
    public var itemHighlightTextColor: UIColor = UIColor.white
    
    // Month/Year view background color
    @IBInspectable
    public var monthBackgroundColor: UIColor = UIColor.clear
    
    // Month/Year view text color
    @IBInspectable
    public var topViewItemColor: UIColor = UIColor.black
    
    // Header view items font
    public var headersFont: UIFont = UIFont(name: "Vazir-Medium", size: 16)!
    // Calendar items font
    public var itemsFont: UIFont = UIFont(name: "Vazir-Bold", size: 14)!
    // Date selection closure
    public var dateSelectHandler: ((_ date: Date) -> ())? = nil
    
    // Internal private variables
    public var currentDate: Date!
    
    fileprivate var headers: [String] = []
    fileprivate var datesArray: [(date: Date, day: Int, week: Int)?] = []
    fileprivate var calendar: Calendar = Date().currentCalendar
    fileprivate var startDate: Date!
    fileprivate var numberOfDaysInWeek: Int = 0
    fileprivate var firstDayOfWeek = 0
    fileprivate var lastIndex: IndexPath? = nil
    fileprivate var todayIndex: IndexPath? = nil
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var monthView: UIView!
    fileprivate var monthViewLabel: UILabel!
    fileprivate var direction: fontDirection = .leftToRight
    fileprivate enum fontDirection: Int{
        case leftToRight, rightToLeft
    }
    
    //MARK: - Views
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createViews()
    }
    
    public func createViews(){
        initializeVars()
        generateMainCalendarView()
        createMonthView()
        generateHeaders()
        
        DispatchQueue.main.async {
            self.generateDates()
        }
    }
    
    fileprivate func createMonthView(){
        monthView = UIView()
        monthView.backgroundColor = monthBackgroundColor
        monthView.translatesAutoresizingMaskIntoConstraints = false
        
        monthViewLabel = UILabel()
        monthViewLabel.text = currentMonthYearInfo
        monthViewLabel.font = headersFont
        monthViewLabel.textColor = topViewItemColor
        monthViewLabel.sizeToFit()
        monthViewLabel.textAlignment = .right
        monthViewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        monthView.addSubview(monthViewLabel)
        addSubview(monthView)
        
        setMonthViewConstraints()
        setCollectionViewConstraints()
    }
    
    fileprivate func generateMainCalendarView(){
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        if direction == .rightToLeft{
            collectionView.semanticContentAttribute = .forceRightToLeft
        }
        collectionView.backgroundColor = UIColor.clear
        collectionView.allowsMultipleSelection = false
        collectionView.isUserInteractionEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GDCalendarItemCell.self, forCellWithReuseIdentifier: "calendar_cell")
        
        setCollectionviewGestures()
        addSubview(collectionView)
    }
    
    private func setCollectionviewGestures(){
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeLeft.direction = .left
        swipeLeft.delegate = self
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRight.direction = .right
        swipeRight.delegate = self
        
        collectionView.addGestureRecognizer(swipeLeft)
        collectionView.addGestureRecognizer(swipeRight)
    }
    
    // MARK: - Constraints
    fileprivate func setMonthViewConstraints(){
        monthViewLabel.rightAnchor.constraint(equalTo: monthView.rightAnchor, constant: -24.0).isActive = true
        monthViewLabel.centerYAnchor.constraint(equalTo: monthView.centerYAnchor, constant: 0.0).isActive = true
        
        monthView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        monthView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0.0).isActive = true
        monthView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0.0).isActive = true
        monthView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        monthView.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    fileprivate func setCollectionViewConstraints(){
        monthView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -6.0).isActive = true
        let padding = ((frame.width - 48) / 7) / 3.5
        collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24 - padding).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24 + padding).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 30.0).isActive = true
    }
    
    // MARK: - Initiate Variables
    fileprivate func initializeVars(){
        calendar = Date().currentCalendar
        currentDate = Date().today
        startDate = currentDate.startDayOfWeek
        numberOfDaysInWeek = currentDate.daysInWeek
        
        var langCode = "en"
        if let lcode = calendar.locale?.languageCode{
            langCode = lcode
        }
        direction = NSLocale.characterDirection(forLanguage: langCode).rawValue == 2 ? .rightToLeft : .leftToRight
    }
    
    fileprivate func generateDates(){
        datesArray = generateDatesData()
        reloadDays()
    }
    
    public func reloadDays() {
        collectionView.reloadSections([1])
    }
    
    fileprivate func setDates(){
        startDate = currentDate.startDayOfWeek
        numberOfDaysInWeek = currentDate.daysInWeek
    }
    
    //MARK: - Funcs
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left{
            gotoPreviousWeek()
        }else if sender.direction == .right{
            gotoNextWeek()
        }
    }
    
    public func gotoNextWeek(){
        currentDate = currentDate.nextWeek
        setDates()
        generateDates()
        
        monthViewLabel.text = currentMonthYearInfo
    }
    
    public func gotoPreviousWeek(){
        currentDate = currentDate.previousWeek
        setDates()
        generateDates()
        
        monthViewLabel.text = currentMonthYearInfo
    }
    
    private func generateHeaders(){
        let startDay = calendar.firstWeekday
        if startDay == 7{
            var temp = Date().daysVeryShort
            let last = temp.popLast()!
            headers = temp
            headers.insert(last, at: 0)
        }else{
            headers = Date().days
        }
    }
    
    private func generateDatesData() -> [(date: Date, day: Int, week: Int)?] {
        datesArray.removeAll()
        
        let today = startDate
        
        var dates: [(date: Date, day: Int, week: Int)?] = []
        if direction == .rightToLeft {
            firstDayOfWeek = startDate.startingDayOfWeek
        } else {
            firstDayOfWeek = startDate.startingDayOfWeek - 1
        }
        if firstDayOfWeek != 7 {
            var dummyDay = calendar.date(byAdding: .day, value: -firstDayOfWeek, to: startDate)!
            for _ in 0 ..< firstDayOfWeek {
                dates.append((dummyDay, dummyDay.componentsOfDate.2, dummyDay.componentsOfDate.3))
                dummyDay = calendar.date(byAdding: .day, value: 1, to: dummyDay)!
            }
        }
        while startDate.componentsOfDate.month != today?.componentsOfDate.month {
            dates.append((startDate, startDate.componentsOfDate.2, startDate.componentsOfDate.3))
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
        for _ in 0 ..< numberOfDaysInWeek {
            if startDate.componentsOfDate.3 == today?.componentsOfDate.3 {
                dates.append((startDate, startDate.componentsOfDate.2, startDate.componentsOfDate.3))
                startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            }
        }
        while dates.count < 7 {
            dates.append((startDate, startDate.componentsOfDate.2, startDate.componentsOfDate.3))
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
        return dates
    }
    
    private var currentMonthYearInfo: String{
        let dateComps = currentDate.componentsOfDate
        let month = Date().months[dateComps.month - 1]
        
        return "\(month) \(dateComps.year)".convertNumbers
    }
    
    //MARK: Set today
    func selectToday() {
        initializeVars()
        monthViewLabel.text = currentMonthYearInfo
        DispatchQueue.main.async {
            self.generateDates()
        }
        currentDate = Date().today
        dateSelectHandler?(Date().today)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension GDCalendar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return headers.count
        }else{
            return datesArray.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GDCalendarItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendar_cell", for: indexPath) as! GDCalendarItemCell
        
        if indexPath.section == 0{
            let currTitle: String = headers[indexPath.row]
            cell.setupCell(value: currTitle, headerBackColor: headerBackgroundColor, headerItemColor: headerItemColor)
        }else{
            guard let currDate = datesArray[indexPath.row] else{
                cell.setupCell(value: "", itemColor: UIColor.clear)
                cell.unhighlightCell()
                
                return cell
            }
            
            cell.setupCell(value: String(currDate.day).convertNumbers, itemColor: itemsColor)
            
            if currDate.date.isToday(date: Date().today){
                cell.highlightCell(highlightColor: itemHighlightColor, textColor: itemHighlightTextColor)
                lastIndex = indexPath
                //MARK: Here
                todayIndex = indexPath
            }else{
                cell.unhighlightCell()
            }
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            return
        }else{
            guard let item = datesArray[indexPath.row] else{
                return
            }
            if let index = lastIndex{
                if let cellToClear: GDCalendarItemCell = collectionView.cellForItem(at: index) as? GDCalendarItemCell{
                    cellToClear.unhighlightCell()
                }
            }
            lastIndex = indexPath
            let cell: GDCalendarItemCell = collectionView.cellForItem(at: indexPath) as! GDCalendarItemCell
            cell.highlightCell(highlightColor: itemHighlightColor, textColor: itemHighlightTextColor)
            
            currentDate = item.date
            dateSelectHandler?(item.date)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (frame.width - 48) / 7, height: (frame.width - 48) / 7)
        return CGSize(width: (frame.width - 48) / 7, height: 45)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
