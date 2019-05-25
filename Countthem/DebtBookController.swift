//
//  DebtBookController.swift
//  Countthem
//
//  Created by Accurate on 22/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

struct Debt1 {
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
    //Debt Book Helper
    let debtBookHelper = DebtBookHelper()
    
    
    var debtsNames = [Debt]()
    
    var debtorsNames = [Debtor]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        debtsNames = debtBookHelper.getDebts()
        debtCollectionView.reloadData()
        
        debtorsNames = debtBookHelper.getDebtors()
        debtorCollectionView.reloadData()
        
        guard let navBar = navigationController?.navigationBar else { return }
        guard let tabBar = tabBarController?.tabBar else { return }
        setupTabbar(tabBar)
        setupNavBar(navBar)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        if array is [Debt] {
            let array: [Debt] = array as! [Debt]
            cell.nameLabel.text = array[indexPath.row].name!
            cell.priceLabel.text = "$\(array[indexPath.row].money)"
            cell.dateLabel.text = dateFormatter.string(from: array[indexPath.row].date! as Date)
        } else if array is [Debtor] {
            let array: [Debtor] = array as! [Debtor]
            cell.nameLabel.text = array[indexPath.row].name!
            cell.priceLabel.text = "-$\(array[indexPath.row].money)"
            cell.dateLabel.text = dateFormatter.string(from: array[indexPath.row].date! as Date)
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

// MARK: Setting segues
extension DebtBookController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddItemDebtBookController
        if segue.identifier == "AddDebt" {
            print("segue is add debt")
            vc.title = "Add Debt"
            vc.addWhat = "Debt"
        } else if segue.identifier == "AddDebtor" {
            print("segue is add debtor")
            vc.title = "Add Debtor"
            vc.addWhat = "Debtor"
        }
    }
    
    @IBAction func addButton(sender: UIButton) {
        
    }
}

// MARK: Setup Tab Bar
extension DebtBookController {
    
    func setupTabbar(_ tabBar: UITabBar) {
        tabBar.isHidden = false
        tabBar.isTranslucent = false
    }
    
}

