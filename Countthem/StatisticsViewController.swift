//
//  StatisticsViewController.swift
//  Countthem
//
//  Created by Accurate on 29/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit
import FSCalendar
import SimplePDF
import PDFKit

class StatisticsViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    fileprivate weak var calendar: FSCalendar!
    
    // MARK: - Helpers
    let appDesingHelper = AppDesingHelper()
    let expensesHelper = ExpensesHelper()
    let categoriesHelper = CategoriesHelper()
    let currencyHelper = CurrencyHelper()
    let pdfManager = PDFManager()
    
    // MARK: - Views
    let segmentedControll: UISegmentedControl = {
        let calendarTitle = NSLocalizedString("Calendar", comment: "The title of the calendar")
        let statsTitle = NSLocalizedString("Stats", comment: "The title of the stats for segmented controll")
        let appDesignHelper = AppDesingHelper()
        let items = [calendarTitle, statsTitle]
        let controll = UISegmentedControl(items: items)
        controll.translatesAutoresizingMaskIntoConstraints = false
        controll.tintColor = appDesignHelper.mainColor
        controll.addTarget(self, action: #selector(segmentedControllAction(_:)), for: .valueChanged)
        controll.backgroundColor = appDesignHelper.backgroundColor
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
        let labelString = NSLocalizedString("On day", comment: "The label is for main info")
        label.text = labelString
        label.textAlignment = .center
        label.font = label.font.withSize(24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let totalDayValue: UILabel = {
        let label = UILabel()
        label.text = "\(CurrencyHelper().getCurrentSign())0.0"
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
        let labelString = NSLocalizedString("On", comment: "The label is for main info")
        label.text = labelString
        label.textAlignment = .center
        label.font = label.font.withSize(24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let totalMonthValue: UILabel = {
        let label = UILabel()
        label.text = "\(CurrencyHelper().getCurrentSign())0.0"
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
    var allExpenses: [Expense]?
    var expenses: [Expense]?
    var categories: [Category]?
    var currentDate = Date()
    var dateOfCalendar: Date?
    var totalDay: Double = 0.0
    var totalMonth: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupViews()
        segmentedControll.selectedSegmentIndex = 0
        setupForCalendar()
        
        self.calendar = calendarView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        expenses = expensesHelper.getExpensesWithDate(date: currentDate)
        allExpenses = expensesHelper.getExpenses()
        
        if let expenses = expenses, let allExpenses = allExpenses {
            totalDayValue.text = "\(currencyHelper.getCurrentSign())\(setTotalDay(expenses: expenses, date: currentDate))"
            totalMonthValue.text = "\(currencyHelper.getCurrentSign())\(setTotalMonth(expenses: allExpenses, date: currentDate))"
        } else {
            totalDayValue.text = "\(currencyHelper.getCurrentSign())0.0"
            totalMonthValue.text = "\(currencyHelper.getCurrentSign())0.0"
        }
        
        categories = categoriesHelper.getCategories()
        calendarTableView.reloadData()
        statsTableView.reloadData()
        calendarTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

}

// MARK: - Setup Views Method
extension StatisticsViewController {
    
    /*
     The method setups the views which are needed for the whole statistics view.
     */
    func setupViews() {
        
        // Setups colours
        view.backgroundColor = appDesingHelper.backgroundColor
        
        // Adding Subviews
        view.addSubview(segmentedControll)
        
        // *** AutoLayout ***
        NSLayoutConstraint.activate([
            segmentedControll.widthAnchor.constraint(equalToConstant: 200),
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
        
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        calendarView.delegate = self
        calendarView.dataSource = self
        
        // Remove The stats view
        statsTableView.removeFromSuperview()
        
        // Setup Calendar Cell
        calendarCell = UITableViewCell(frame: CGRect.zero)
        calendarCell?.addSubview(calendarView)
        
        // Setup Main Info Cell
        
        mainInfoCell = UITableViewCell(frame: CGRect.zero)
        dayStack.addArrangedSubview(totalDayTitle)
        dayStack.addArrangedSubview(totalDayValue)
        monthStack.addArrangedSubview(totalMonthTitle)
        monthStack.addArrangedSubview(totalMonthValue)
        mainInfoCell?.backgroundColor = appDesingHelper.backgroundColor
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
        mainInfoCell?.backgroundColor = appDesingHelper.backgroundColor
        calendarTableView.backgroundColor = appDesingHelper.backgroundColor
        calendarTableView.separatorStyle = .none
        
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
        cell?.expensePrice.text = "\(currencyHelper.getCurrentSign())\(expenses[indexPath.row].price)"
        cell?.backgroundColor = appDesingHelper.backgroundColor
        return cell!
    }
    
    /*
     In case when Segmented contoll is switching on stats, the method is invoked.
     The method setups the views which are needed for the Stats View
     */
    func setupForStats() {
        calendarTableView.removeFromSuperview()
        statsTableView.delegate = self
        statsTableView.dataSource = self
        statsTableView.separatorStyle = .none
        
        // Adding subiew
        view.addSubview(statsTableView)
        
        //*** AutoLayout ***
        NSLayoutConstraint.activate([
            statsTableView.topAnchor.constraint(equalTo: segmentedControll.bottomAnchor, constant: 16),
            statsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    /*
     Additinal method for the stats view
     */
    func setupStatsCell(categories: [Category], tableView: UITableView, reuseIdentifier: String, indexPath: IndexPath) -> StatsTableViewCell {
        print("Setup stats cell")
        tableView.register(StatsTableViewCell.self, forCellReuseIdentifier: "StatsListCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? StatsTableViewCell
        cell?.categoryIcon.image = UIImage(named: categories[indexPath.row].icon!)
        cell?.categoryName.text = categories[indexPath.row].name
        cell?.totalMoneyLabel.text = "\(currencyHelper.getCurrentSign())\(categoriesHelper.getTotalAmountOfCategory(category: categories[indexPath.row]))"
        return cell!
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
            self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(moreButtonAction(sender:))), animated: true)
            navBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}

// MARK: - Setup Segmented Controller
extension StatisticsViewController {
    
    @objc func segmentedControllAction(_ segmentedControll: UISegmentedControl) {
        switch segmentedControll.selectedSegmentIndex {
        case 0:
            setupForCalendar()
            calendarTableView.reloadData()
        case 1:
            setupForStats()
            statsTableView.reloadData()
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
        case statsTableView:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = expenses?.count else { return 0 }
        guard let categoriesCount = categories?.count else { return 0 }
        
        switch tableView {
        case calendarTableView:
            //return count + 3
            switch section {
            case 0: return 2
            case 1: return count
            default: return 0
            }
        case statsTableView:
            switch section {
            case 0: return categoriesCount
            default: return 0
            }
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
        } else if tableView == statsTableView {
            switch indexPath.section {
            case 0: return setupStatsCell(categories: categories!, tableView: tableView, reuseIdentifier: "StatsListCell", indexPath: indexPath)
            default: fatalError()
            }
        }
        return UITableViewCell()
    }
}

extension StatisticsViewController {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        expenses = expensesHelper.getExpensesWithDate(date: date)
        allExpenses = expensesHelper.getExpenses()
        totalDayValue.text = "\(currencyHelper.getCurrentSign())\(setTotalDay(expenses: expenses!, date: date))"
        totalMonthValue.text = "\(currencyHelper.getCurrentSign())\(setTotalMonth(expenses: allExpenses!, date: date))"
        calendarTableView.reloadData()
    }
}

// MARK: - Seting value for Titles
extension StatisticsViewController {
    
    func setTotalDay(expenses: [Expense], date: Date) -> Double {
        print("Call the set total method")
        var totalDay: Double = 0.0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let date1 = dateFormatter.string(from: date)
        
        for expense in expenses {
            let date2 = dateFormatter.string(from: expense.date!)
            if date1 == date2 {
                totalDay += expense.price
            }
        }
        
        return totalDay
    }
    
    func setTotalMonth(expenses: [Expense], date: Date) -> Float {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date)
        let auxString = NSLocalizedString("On", comment: "Still for main info")
        totalMonthTitle.text = "\(auxString) \(nameOfMonth):"
        
        for expense in expenses {
            let monthToCompare = dateFormatter.string(from: expense.date!)
            if nameOfMonth == monthToCompare {
                totalMonth += Float(expense.price)
            }
        }
        return totalMonth
    }
    
}

// MARK: - Auxiliary menu methods
/*
 The user can create a pdf file to see his statistic in more user-friendly format with the menu.
 Also the user can clear his statistic. It means the app will clean all the user's data.
 */
extension StatisticsViewController {
    
    @objc func moreButtonAction(sender: UIBarButtonItem) {
        let menuActionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let createPDFButton = UIAlertAction(title: "Export to PDF", style: .default) { _ in
            self.createPDF()
        }
        let clearDataButton = UIAlertAction(title: "Clear Statistics", style: .destructive) { _ in
            self.cleanData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel button tapped")
        }
        menuActionController.addAction(createPDFButton)
        menuActionController.addAction(clearDataButton)
        menuActionController.addAction(cancelButton)
        present(menuActionController, animated: true, completion: nil)
    }
    
    func createPDF() {
        pdfManager.writePDF(title: "Statistics")
        if let url = pdfManager.getURL() {
            showPDFMethod(url: url)
        }
    }
    
    func showPDFMethod(url: URL) {
        let vc = PDFViewController()
        vc.url = url
        present(vc, animated: true, completion: nil)
    }
    
    func cleanData() {
        let alertController = UIAlertController(title: nil, message: "Are you sure to delete all data?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .destructive) { _ in
            let expenses = self.expensesHelper.getExpenses()
            for expense in expenses {
                self.expensesHelper.removeExpenses(expense: expense)
                self.showDoneMessage()
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel button tapped")
        }
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func showDoneMessage() {
        let alertController = UIAlertController(title: nil, message: "Done!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true) {
            self.allExpenses = self.expensesHelper.getExpenses()
            self.expenses = self.expensesHelper.getExpensesWithDate(date: self.currentDate)
            self.totalDay = 0.0
            self.totalMonth = 0.0
            self.viewWillAppear(true)
            self.calendarTableView.reloadData()
        }
    }
    
}


