//
//  AddItemDebtBookController.swift
//  Countthem
//
//  Created by Accurate on 25/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

class AddItemDebtBookController: UITableViewController {
    
    let appDesignHelper = AppDesingHelper()
    
    let debtBookHelper = DebtBookHelper()
    
    var addWhat: String?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationController?.navigationItem.title = title ?? "Title"
        if let tabBar = tabBarController?.tabBar {
            setupTabbar(tabBar)
        }
        setupTableView()
        
        let currentDate = Date()
        datePicker.date = currentDate
        
        nameTextField.delegate = self
        moneyTextField.delegate = self
    }
    
    // Design Table view
    func setupTableView() {
        tableView.backgroundColor = UIColor(hexString: appDesignHelper.backgroundColor)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        default:
            fatalError()
        }
    }

}

// MARK: Setup Tab Bar
extension AddItemDebtBookController {
    
    func setupTabbar(_ tabBar: UITabBar) {
        tabBar.isHidden = true
        tabBar.isTranslucent = true
    }
    
}

extension AddItemDebtBookController: UITextFieldDelegate {
    
}

// MARK: Adding logic
extension AddItemDebtBookController {
    
    @IBAction func done() {
        if let name = nameTextField.text,
            let money = moneyTextField.text {
            let date = datePicker.date
            let convertedMoney = Double(money)
            let convertedDate = date as NSDate
            if let addWhat = addWhat, name != "", money != "" {
                if addWhat == "Debt" {
                    debtBookHelper.addDebt(name: name, money: convertedMoney!, date: convertedDate)
                } else if addWhat == "Debtor" {
                    debtBookHelper.addDebtor(name: name, money: convertedMoney!, date: convertedDate)
                }
                navigationController?.popViewController(animated: true)
                
            }
        }
        
    }
    
}
