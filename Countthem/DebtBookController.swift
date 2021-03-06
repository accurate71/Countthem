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
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyLabel2: UILabel!
    @IBOutlet weak var debtTitleLabel: UILabel!
    @IBOutlet weak var debtorTitleLabel: UILabel!
    // Buttons
    @IBOutlet weak var addButton1: UIButton!
    @IBOutlet weak var addButton2: UIButton!
    // TextFields
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Helpers
    let appDesignHelper = AppDesingHelper()
    let debtBookHelper = DebtBookHelper()
    let appAnimation = AppAnimationHelper()
    let currencyHelper = CurrencyHelper()
    
    var sharedIndexPath: IndexPath?
    var toDelete = String()
    var targetCell: UICollectionViewCell?
    
    var debtsNames = [Debt]()
    
    var debtorsNames = [Debtor]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton1.tintColor = appDesignHelper.mainColor
        addButton2.tintColor = appDesignHelper.mainColor
        
        setDebtsDebtors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDebtsDebtors()
        
        guard let navBar = navigationController?.navigationBar else { return }
        guard let tabBar = tabBarController?.tabBar else { return }
        setupTabbar(tabBar)
        setupNavBar(navBar)
        setupTableView()
        setupCollectionViews()
        setupTitles()
    }
    
    func setDebtsDebtors() {
        debtsNames = debtBookHelper.getDebts()
        debtorsNames = debtBookHelper.getDebtors()
        
        if debtsNames.isEmpty {
            emptyLabel.isHidden = false
            emptyLabel.text = "Your list of debts is empty"
            emptyLabel.textColor = appDesignHelper.mainColor
        } else {
            emptyLabel.isHidden = true
        }
        
        if debtorsNames.isEmpty {
            emptyLabel2.isHidden = false
            emptyLabel2.text = "Your list of debts is empty"
            emptyLabel2.textColor = appDesignHelper.mainColor
        } else {
            emptyLabel2.isHidden = true
        }
        debtCollectionView.reloadData()
        debtorCollectionView.reloadData()
    }
    
    // Design Titles
    func setupTitles() {
        let debtBookTitleString = NSLocalizedString("Debt book", comment: "The main title of the screen")
        title = debtBookTitleString
        debtTitleLabel.textColor = appDesignHelper.anotherColor
        debtorTitleLabel.textColor = appDesignHelper.anotherColor
    }
    
    // Design Collection Views
    func setupCollectionViews() {
        debtCollectionView.backgroundColor = appDesignHelper.backgroundColor
        debtorCollectionView.backgroundColor = appDesignHelper.backgroundColor
    }
    
    // Design Table view
    func setupTableView() {
        tableView.backgroundColor = appDesignHelper.backgroundColor
    }
}

// MARK: - Table view data source
extension DebtBookController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = appDesignHelper.backgroundColor
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
        //let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(testMethod(sender:)))
        if collectionView == debtCollectionView {
            let cell = collectionView.cellForItem(at: indexPath)
            if let cell = cell {
                toDelete = "Debt"
                sharedIndexPath = indexPath
                becomeFirstResponder()
                appAnimation.clickButton(view: cell, color1: UIColor.white, color2: appDesignHelper.anotherColor) {
                    self.showMenuSheet(cell: cell)
                }
                
            }
        } else if collectionView == debtorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath)
            if let cell = cell {
                toDelete = "Debtor"
                sharedIndexPath = indexPath
                becomeFirstResponder()
                appAnimation.clickButton(view: cell, color1: UIColor.white, color2: appDesignHelper.anotherColor) {
                    self.showMenuSheet(cell: cell)
                }
            }
        }
        
        
    }
    
    func showMenuSheet(cell: UICollectionViewCell) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            print("Delete button tapped")
            if let indexPath = self.sharedIndexPath {
                if self.toDelete == "Debt" {
                    self.debtBookHelper.removeDebts(debt: self.debtsNames[indexPath.row])
                    self.debtsNames.remove(at: indexPath.row)
                    self.debtCollectionView.reloadData()
                    self.appAnimation.animationDeleting(for: self.debtCollectionView)
                } else if self.toDelete == "Debtor" {
                    self.debtBookHelper.removeDebtor(debtor: self.debtorsNames[indexPath.row])
                    self.debtorsNames.remove(at: indexPath.row)
                    self.debtorCollectionView.reloadData()
                    self.appAnimation.animationDeleting(for: self.debtorCollectionView)
                }
                self.viewDidLoad()
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel button tapped")
        }
        actionSheetController.addAction(deleteButton)
        actionSheetController.addAction(cancelButton)
        present(actionSheetController, animated: true, completion: nil)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
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
            cell.priceLabel.text = "\(currencyHelper.getCurrentSign())\(array[indexPath.row].money)"
            cell.dateLabel.text = dateFormatter.string(from: array[indexPath.row].date! as Date)
        } else if array is [Debtor] {
            let array: [Debtor] = array as! [Debtor]
            cell.nameLabel.text = array[indexPath.row].name!
            cell.priceLabel.text = "-\(currencyHelper.getCurrentSign())\(array[indexPath.row].money)"
            cell.dateLabel.text = dateFormatter.string(from: array[indexPath.row].date! as Date)
        }
        
        cell.dateLabel.textColor = UIColor.gray
        cell.nameLabel.textColor = appDesignHelper.mainColor
    }
    
    func setupCollectionView(_ view: UICollectionView) {
        view.backgroundColor = appDesignHelper.backgroundColor
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
    }
    
}

// MARK: - Setting segues
extension DebtBookController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let debtTitleString = NSLocalizedString("Add debt", comment: "The screen for adding debt")
        let debtorTitleString = NSLocalizedString("Add debtor", comment: "The screen for adding debtor")
        let vc = segue.destination as! AddItemDebtBookController
        if segue.identifier == "AddDebt" {
            print("segue is add debt")
            vc.title = debtTitleString
            vc.addWhat = "Debt"
        } else if segue.identifier == "AddDebtor" {
            print("segue is add debtor")
            vc.title = debtorTitleString
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

