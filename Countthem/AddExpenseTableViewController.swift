//
//  AddExpenseTableViewController.swift
//  Countthem
//
//  Created by Accurate on 18/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit
// TODO: Навести порядок в коде, добавить описание к этому контроллеру
class AddExpenseTableViewController: UITableViewController {
    
    var category: Category?
    var name: String?
    var price: String?
    
    // Getting the current date
    let currentDate = NSDate()
    
    //Create a formatter, to show the date with a good format
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navbar = navigationController?.navigationBar, let tabBar = tabBarController?.tabBar {
            setupNavBar(navbar)
            setupTabbar(tabBar)
        }
        setupTableView()
        
        
    }
    
    // The action method is created for Right Bar Button "Add"
    // The method is getting the main info and adding the expense to the datebase with Expense Helper class
    @objc func addExpenseAction(sender: UIBarButtonItem) {
        
        let cell1 = tableView.cellForRow(at: IndexPath(row: 0, section: 2))
        let textfiled1  = cell1!.viewWithTag(11) as! UITextField
        let cell2 = tableView.cellForRow(at: IndexPath(row: 0, section: 3))
        let textfiled2  = cell2!.viewWithTag(22) as! UITextField
        price = textfiled2.text
        name = textfiled1.text
        if let name = name, let price = price, let category = category {
            print("I'm working")
            if name == "" || price == "" {
                showAlert()
            } else {
                let convertedPrice: Double = {
                    if price.contains(",") {
                        let priceRus = price.replacingOccurrences(of: ",", with: ".")
                        return Double(priceRus)!
                    } else {
                        return Double(price)!
                    }
                }()
                ExpensesHelper().addExpense(name: name, price: convertedPrice, date: currentDate, category: category)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    // In case if the user didn't fill the fields before tapping button, the alert will be shown.
    func showAlert() {
        let alertControllerTitle = NSLocalizedString("Warning", comment: "The title of alert controller")
        let message = NSLocalizedString("Please, fill the fields", comment: "The message of errors")
        let alertController = UIAlertController(title: alertControllerTitle, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK!", style: .cancel, handler: nil)
        alertController.addAction(actionOk)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 1
        default:
            fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // MARK: Setup Views for Cells
        //The text field is using for getting Expense name
        let nameTextField: UITextField = {
            let field = UITextField()
            field.placeholder = NSLocalizedString("Expense name", comment: "The textfield place holder")
            field.tag = 11
            field.translatesAutoresizingMaskIntoConstraints = false
            field.clearButtonMode = .whileEditing
            return field
        }()
        
        // The text field is using for getting Expense price
        let priceTextField: UITextField = {
            let field = UITextField()
            field.placeholder = NSLocalizedString("Expense price", comment: "The textfield place holder")
            field.tag = 22
            field.translatesAutoresizingMaskIntoConstraints = false
            field.clearButtonMode = .whileEditing
            field.keyboardType = .decimalPad
            return field
        }()
        
        // The label is presenting the current date.
        let dateLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        dateLabel.text = dateFormatter.string(from: currentDate as Date)
        
        // The ImageView is showing the image of the category
        let categoryImage: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        // The Label is showing the name of the category
        let categoryName: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // Setup the cell which show represent Category information
        if let category = category {
            categoryImage.image = UIImage(named: category.icon!)
            categoryName.text = category.name
        }
        let chosenCategoryCell: UITableViewCell = {
            let cell = UITableViewCell()
            cell.addSubview(categoryImage)
            cell.addSubview(categoryName)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(44)]-[v1]|", options: .init(), metrics: nil, views: ["v0": categoryImage, "v1": categoryName]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0(44)]-16-|", options: .init(), metrics: nil, views: ["v0": categoryImage]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: .init(), metrics: nil, views: ["v0": categoryName]))
            return cell
        }()
        
        // MARK: Setup cells
        // Showing Date cell
        let dateCell: UITableViewCell = {
            let cell = UITableViewCell()
            cell.addSubview(dateLabel)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": dateLabel]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": dateLabel]))
            return cell
        }()
        // Typing an expense name cell
        let typeNameCell: UITableViewCell = {
            let cell = UITableViewCell()
            cell.addSubview(nameTextField)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": nameTextField]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": nameTextField]))
            return cell
        }()
        // Typing an expense price
        let typePriceCell: UITableViewCell = {
            let cell = UITableViewCell()
            cell.addSubview(priceTextField)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": priceTextField]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": priceTextField]))
            return cell
        }()
        
        switch indexPath.section {
        case 0:
            return chosenCategoryCell // The showing category cell
        case 1: return dateCell // The inserting Expense name cell
        case 2: return typeNameCell
        case 3: return typePriceCell
        default: return UITableViewCell()
        }

        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return NSLocalizedString("Category", comment: "The header for category")
        case 1: return NSLocalizedString("Date", comment: "The header for date")
        case 2: return NSLocalizedString("Type an expense name", comment: "The header for textfield")
        case 3: return NSLocalizedString("Type an expense price", comment: "The header for textfield")
        default:
            fatalError()
        }
    }

}
// MARK: Setup Navigation Bar
extension AddExpenseTableViewController {
    
    func setupNavBar(_ navbar:UINavigationBar){
        navbar.tintColor = UIColor.white
        navbar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Add", comment: "Add button"), style: .done, target: self, action: #selector(addExpenseAction(sender:)))
        navigationController?.navigationBar.prefersLargeTitles = false
        title = NSLocalizedString("Add Expense", comment: "The title of Add expense page")
    }
    
}

// MARK: Setup Table View
extension AddExpenseTableViewController {
    
    func setupTableView() {
        tableView = UITableView.init(frame: CGRect.init(), style: .grouped)
        tableView.allowsSelection = false
    }
    
}

// MARK: Setup Tab Bar
extension AddExpenseTableViewController {
    
    func setupTabbar(_ tabBar: UITabBar) {
        tabBar.isHidden = true
        tabBar.isTranslucent = true
    }
    
}
