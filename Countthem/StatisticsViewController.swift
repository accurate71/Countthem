//
//  StatisticsViewController.swift
//  Countthem
//
//  Created by Accurate on 29/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit
import FSCalendar

class StatisticsViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    fileprivate weak var calendar: FSCalendar!
    let itemsForTest: [String] = ["Bilba", "Bilba", "Bilba", "Bilba", "Bilba", "Bilba"]
    
    // MARK: - Helpers
    let appDesingHelper = AppDesingHelper()
    let expensesHelper = ExpensesHelper()
    
    // MARK: - Views
    let segmentedControll: UISegmentedControl = {
        let appDesignHelper = AppDesingHelper()
        let items = ["Calendar", "Stats"]
        let controll = UISegmentedControl(items: items)
        controll.translatesAutoresizingMaskIntoConstraints = false
        controll.tintColor = appDesignHelper.mainColor
        controll.addTarget(self, action: #selector(segmentedControllAction(_:)), for: .valueChanged)
        controll.backgroundColor = UIColor(hexString: appDesignHelper.backgroundColor)
        return controll
    }()
    let calendarView: FSCalendar = {
        let appDesignHelper = AppDesingHelper()
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.appearance.headerTitleColor = appDesignHelper.mainColor
        calendar.appearance.selectionColor = appDesignHelper.mainColor
        calendar.appearance.weekdayTextColor = appDesignHelper.mainColor
        return calendar
    }()
    // MARK: - Views for Calendar Table View
    let calendarTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.allowsMultipleSelection = false
        tableView.allowsSelection = false
        return tableView
    }()
    var calendarCell: UITableViewCell?
    let totalDayTitle: UILabel = {
        let label = UILabel()
        label.text = "On Day:"
        label.textAlignment = .center
        label.font = label.font.withSize(24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let totalDayValue: UILabel = {
        let label = UILabel()
        label.text = "$---"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dayStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.spacing = 8
        return stack
    }()
    let totalMonthTitle: UILabel = {
        let label = UILabel()
        label.text = "On Month:"
        label.textAlignment = .center
        label.font = label.font.withSize(24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let totalMonthValue: UILabel = {
        let label = UILabel()
        label.text = "$----"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let monthStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.spacing = 8
        return stack
    }()
    var mainInfoCell: UITableViewCell?
    var expensesListCell: ExpenseTableViewCell?
    
    // MARK: - Views for Stats table view
    let statsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.allowsMultipleSelection = false
        return tableView
    }()
    
    // Variables
    var expenses: [Expense]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupViews()
        segmentedControll.selectedSegmentIndex = 0
        setupForCalendar()
        
        calendarView.delegate = self
        calendarView.dataSource = self
        self.calendar = calendarView
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        statsTableView.delegate = self
        statsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        expenses = expensesHelper.getExpenses()
        calendarTableView.reloadData()
    }

}

// MARK: - Setup Views Method
extension StatisticsViewController {
    
    /*
     The method setups the views which are needed for the whole statistics view.
     */
    func setupViews() {
        
        // Setups colours
        view.backgroundColor = UIColor(hexString: appDesingHelper.backgroundColor)
        
        // Adding Subviews
        view.addSubview(segmentedControll)
        
        // *** AutoLayout ***
        NSLayoutConstraint.activate([
            segmentedControll.widthAnchor.constraint(equalToConstant: 150),
            segmentedControll.heightAnchor.constraint(equalToConstant: 30),
            segmentedControll.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControll.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
            ])
    }
    
    /*
     In case when Segmented contoll is switching on calendar, the method is invoked.
     The method setups the views which are needed for the Calendar View
     */
    func setupForCalendar() {
        
        // Setup Calendar Cell
        calendarCell = UITableViewCell(frame: CGRect.zero)
        calendarCell?.addSubview(calendarView)
        
        // Setup Main Info Cell
        mainInfoCell = UITableViewCell(frame: CGRect.zero)
        dayStack.addArrangedSubview(totalDayTitle)
        dayStack.addArrangedSubview(totalDayValue)
        monthStack.addArrangedSubview(totalMonthTitle)
        monthStack.addArrangedSubview(totalMonthValue)
        mainInfoCell?.backgroundColor = UIColor(hexString: appDesingHelper.backgroundColor)
        let stackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [dayStack,monthStack])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .horizontal
            stack.distribution = .equalCentering
            stack.spacing = 20
            return stack
        }()
        mainInfoCell?.addSubview(stackView)
        
        // Setups colours
        totalDayTitle.textColor = appDesingHelper.mainColor
        totalMonthTitle.textColor = appDesingHelper.mainColor
        mainInfoCell?.backgroundColor = UIColor(hexString: appDesingHelper.backgroundColor)
        calendarTableView.backgroundColor = UIColor(hexString: appDesingHelper.backgroundColor)
        calendarTableView.separatorStyle = .none
        
        // Remove The stats view
        statsTableView.removeFromSuperview()
        
        // Adding subiew
        view.addSubview(calendarTableView)
        
        //*** AutoLayout ***
        // Calendar Cell
        NSLayoutConstraint.activate([
            calendarCell!.heightAnchor.constraint(equalToConstant: 320),
            calendarView.leadingAnchor.constraint(equalTo: calendarCell!.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendarCell!.trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 320)
            ])
        // Main Info Cell
        NSLayoutConstraint.activate([
            mainInfoCell!.heightAnchor.constraint(equalToConstant: 100),
            stackView.centerXAnchor.constraint(equalTo: mainInfoCell!.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: mainInfoCell!.centerYAnchor)
            ])
        //Calendar Table View
        NSLayoutConstraint.activate([
            calendarTableView.topAnchor.constraint(equalTo: segmentedControll.bottomAnchor, constant: 16),
            calendarTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    /*
     Additinal method for the calendar view
     */
    func setupDynamicCell(expenses: [Expense], tableView: UITableView, reuseIdentifier: String, indexPath: IndexPath) -> ExpenseTableViewCell {
        tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: "ExpensesListCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ExpenseTableViewCell
        cell?.categoryImage.image = UIImage(named: expenses[indexPath.row].category?.icon ?? "dinner")
        cell?.nameCategory.text = expenses[indexPath.row].category?.name
        cell?.nameExpense.text = expenses[indexPath.row].name
        cell?.expensePrice.text = "$\(expenses[indexPath.row].price)"
        cell?.backgroundColor = UIColor(hexString: appDesingHelper.backgroundColor)
        return cell!
    }
    
    /*
     In case when Segmented contoll is switching on calendar, the method is invoked.
     The method setups the views which are needed for the Calendar View
     */
    func setupForStats() {
        calendarTableView.removeFromSuperview()
    }
    
}

// MARK: - Setup Navigation Bar Method
/*
 The attributes which are needed to setup for a navigation bar is located in the method.
 */
extension StatisticsViewController {
    func setupNavBar(){
        title = "Statistics"
        if let navBar = self.navigationController?.navigationBar {
            navBar.barTintColor = appDesingHelper.mainColor
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navBar.isTranslucent = false
        }
    }
}

// MARK: - Setup Segmented Controller
extension StatisticsViewController {
    
    @objc func segmentedControllAction(_ segmentedControll: UISegmentedControl) {
        switch segmentedControll.selectedSegmentIndex {
        case 0:
            setupForCalendar()
        case 1:
            setupForStats()
        default:
            fatalError()
        }
    }
    
}

// MARK: - Table View Methods
extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case calendarTableView:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = expenses?.count else {
            return 0
        }
        
        switch tableView {
        case calendarTableView:
            //return count + 3
            switch section {
            case 0: return 2
            case 1: return expenses!.count
            default: return 0
            }
        case statsTableView:
            return count
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == calendarTableView {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    print("Calendar Cell")
                    guard let cell = calendarCell else { return UITableViewCell() }
                    return cell
                case 1:
                    print("Main info cell")
                    guard let cell = mainInfoCell else { return UITableViewCell() }
                    return cell
                default:
                    return UITableViewCell()
                }
            case 1:
                print("dynamic cell")
                if let expenses = expenses {
                    return setupDynamicCell(expenses: expenses, tableView: tableView, reuseIdentifier: "ExpensesListCell", indexPath: indexPath)
                }
                return UITableViewCell()
            default: return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
}
