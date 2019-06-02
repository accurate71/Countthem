//
//  DebtBookController.swift
//  Countthem
//
//  Created by Accurate on 22/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

// TODO: - Change a color of Add buttons
// TODO: - Make a deleting cell function
import UIKit


class DebtBookController: UITableViewController {
    
    // Collections
    @IBOutlet weak var debtCollectionView: UICollectionView!
    @IBOutlet weak var debtorCollectionView: UICollectionView!
    // Titles
    @IBOutlet weak var debtTitleLabel: UILabel!
    @IBOutlet weak var debtorTitleLabel: UILabel!
    // Buttons
    @IBOutlet weak var addButton1: UIButton!
    @IBOutlet weak var addButton2: UIButton!
    
    // MARK: - Helpers
    let appDesignHelper = AppDesingHelper()
    let debtBookHelper = DebtBookHelper()
    let appAnimation = AppAnimationHelper()
    
    var sharedIndexPath: IndexPath?
    var toDelete = String()
    var targetCell: UICollectionViewCell?
    
    var debtsNames = [Debt]()
    
    var debtorsNames = [Debtor]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton1.tintColor = appDesignHelper.mainColor
        addButton2.tintColor = appDesignHelper.mainColor
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

// MARK: - Collection View data source
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(testMethod(sender:)))
        if collectionView == debtCollectionView {
            let cell = collectionView.cellForItem(at: indexPath)
            if let cell = cell {
                toDelete = "Debt"
                sharedIndexPath = indexPath
                becomeFirstResponder()
                cell.addGestureRecognizer(longPressGesture)
                targetCell = cell
                
            }
        } else if collectionView == debtorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath)
            if let cell = cell {
                toDelete = "Debtor"
                sharedIndexPath = indexPath
                becomeFirstResponder()
                cell.addGestureRecognizer(longPressGesture)
                targetCell = cell
            }
        }
    }
    
    @objc func testMethod(sender: Any) {
        if let cell = targetCell {
            showMenu(cell: cell)
        }
    }
    
    func showMenu(cell: UICollectionViewCell) {
        let menuItem = UIMenuItem(title: "Delete", action: #selector(deleteAction(sender:)))
        let menu = UIMenuController.shared
        menu.arrowDirection = .default
        menu.menuItems = [menuItem]
        menu.setTargetRect(CGRect.zero, in: cell.contentView)
        menu.setMenuVisible(true, animated: true)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc func deleteAction(sender: Any) {
        if let indexPath = sharedIndexPath {
            if toDelete == "Debt" {
                debtBookHelper.removeDebts(debt: debtsNames[indexPath.row])
                debtsNames.remove(at: indexPath.row)
                debtCollectionView.reloadData()
                appAnimation.animationDeleting(for: debtCollectionView)
            } else if toDelete == "Debtor" {
                debtBookHelper.removeDebtor(debtor: debtorsNames[indexPath.row])
                debtorsNames.remove(at: indexPath.row)
                debtorCollectionView.reloadData()
                appAnimation.animationDeleting(for: debtorCollectionView)
            }
        }
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

// MARK: - Setup Navigation Bar
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

// MARK: - Setting segues
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
}

// MARK: - Setup Tab Bar
extension DebtBookController {
    
    func setupTabbar(_ tabBar: UITabBar) {
        tabBar.isHidden = false
        tabBar.isTranslucent = false
    }
    
}

