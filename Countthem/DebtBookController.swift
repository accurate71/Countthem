//
//  DebtBookController.swift
//  Countthem
//
//  Created by Accurate on 22/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

struct Debt {
    let name: String?
    let money: String?
    let date: String?
}

struct Debtor {
    let name: String?
    let money: String?
    let date: String?
}

class DebtBookController: UITableViewController {
    
    // Collections
    @IBOutlet weak var debtCollectionView: UICollectionView!
    @IBOutlet weak var debtorCollectionView: UICollectionView!
    // Titles
    @IBOutlet weak var debtTitleLabel: UILabel!
    @IBOutlet weak var debtorTitleLabel: UILabel!
    // Design Helper
    let appDesignHelper = AppDesingHelper()
    
    
    var debtsNames: [Debt] = [Debt(name: "David", money: "$34", date: "22/05/19"),
                              Debt(name: "Alex", money: "$24", date: "22.05.19"),
                              Debt(name: "Moon", money: "$34", date: "22/05/19"),
                              Debt(name: "David", money: "$34", date: "22.05.19")]
    
    var debtorsNames: [Debtor] = [Debtor(name: "Arman", money: "-$34", date: "22/05/19"),
                              Debtor(name: "Alex", money: "-$24", date: "22.05.19"),
                              Debtor(name: "Rick", money: "-$34", date: "22/05/19"),
                              Debtor(name: "David", money: "-$34", date: "22.05.19")]

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navbar = navigationController?.navigationBar {
            setupNavBar(navbar)
        }
        setupTableView()
        setupCollectionViews()
        setupTitles()
    }
    
    // Design Titles
    func setupTitles() {
        debtTitleLabel.textColor = appDesignHelper.anotherColor
        debtorTitleLabel.textColor = appDesignHelper.anotherColor
    }
    
    // Design Collection Views
    func setupCollectionViews() {
        debtCollectionView.backgroundColor = UIColor(hexString: appDesignHelper.backgroundColor)
        debtorCollectionView.backgroundColor = UIColor(hexString: appDesignHelper.backgroundColor)
    }
    
    // Design Table view
    func setupTableView() {
        tableView.backgroundColor = UIColor(hexString: appDesignHelper.backgroundColor)
    }
}

// MARK: - Table view data source
extension DebtBookController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.init(hexString: appDesignHelper.backgroundColor)
    }
}

// MARK: Collection View data source
extension DebtBookController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == debtCollectionView {
            return debtsNames.count
        } else if collectionView == debtorCollectionView {
            return debtorsNames.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = debtCollectionView.dequeueReusableCell(withReuseIdentifier: "DebtCell", for: indexPath) as? Debt_DebtorsCollectionViewCell
        
        if collectionView == debtCollectionView {
            if let cell = cell {
                decorateCell(cell)
                setCell(cell: cell, array: debtsNames, indexPath: indexPath)
                return cell
            }
        } else if collectionView == debtorCollectionView {
            if let cell = cell {
                decorateCell(cell)
                setCell(cell: cell, array: debtorsNames, indexPath: indexPath)
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func decorateCell(_ cell: UICollectionViewCell) {
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 4
        cell.layer.shadowColor = appDesignHelper.anotherColor.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = .init()
        cell.layer.shadowRadius = 4
        cell.layer.masksToBounds = false
        
    }
    func setCell(cell: Debt_DebtorsCollectionViewCell, array: Any, indexPath: IndexPath) {
        if array is [Debt] {
            let array: [Debt] = array as! [Debt]
            cell.nameLabel.text = array[indexPath.row].name!
            cell.priceLabel.text = array[indexPath.row].money!
            cell.dateLabel.text = array[indexPath.row].date!
        } else if array is [Debtor] {
            let array: [Debtor] = array as! [Debtor]
            cell.nameLabel.text = array[indexPath.row].name!
            cell.priceLabel.text = array[indexPath.row].money!
            cell.dateLabel.text = array[indexPath.row].date!
        }
        
        cell.dateLabel.textColor = UIColor.gray
        cell.nameLabel.textColor = appDesignHelper.mainColor
    }
    
    func setupCollectionView(_ view: UICollectionView) {
        view.backgroundColor = UIColor.init(hexString: appDesignHelper.backgroundColor)
    }
    
    
}

// MARK: Setup Navigation Bar
extension DebtBookController {
    
    func setupNavBar(_ navbar:UINavigationBar){
        navbar.barTintColor = appDesignHelper.mainColor
        navbar.tintColor = UIColor.white
        navbar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navbar.prefersLargeTitles = false
        navbar.isTranslucent = false
        title = "Debt Book"
    }
    
}

