//
//  AddCategoryPageViewController.swift
//  Countthem
//
//  Created by Accurate on 13/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

enum AlertError {
    case noName
    case noIcon
}

class AddCategoryPageViewController: UIViewController {
    
    var name: String?
    var icon: String?
    var tableView: UITableView?
    
    // MARK: Category Icons Array
    var categoriesIcons = ["breakfast","bus","cinema",
                           "coffee","dinner",
                           "games","groceries","internet",
                           "lunch","mobile","shopping",
                           "online_shopping", "turism"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSuperview()
        setupViews()
    }
    
    // MARK: Add Button Method
    /*
     The methods checking all the variables, if the user forgot to type a name or choose an icon
    the alert with a specific message will be shown.
     */
    @objc func addButton(sender: UIBarButtonItem) {
        print("Item added")
        
        if let tableView = tableView {
            let nameTextField = tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(11) as? UITextField
            if let field = nameTextField {
                name = field.text
            }
        }
        if name == nil {
            showAlert(error: AlertError.noName)
        } else if icon == nil {
            showAlert(error: AlertError.noIcon)
        } else {
            CategoriesHelper().addCategory(name: name!, icon: icon!)
            navigationController?.popViewController(animated: true)
        }
    }
    
    /*
     Here is the method for Add Button Method
     which builds the alert with a specific message of an error
    */
    func showAlert(error: AlertError) {
        let title = "Something goes wrong"
        var message = ""
        
        switch error {
        case .noName:
            message = "You forgot to type a category name"
        case .noIcon:
            message = "You forgot to choose a category icon"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Setting Superview
    /*
     The method helps to setup the elements of Superview like as Navigation Bar,
     TabBar and some attributes of the view.
    */
    func setupSuperview(){
        self.title = NSLocalizedString("Add category", comment: "title for add category screen")
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Add", comment: "Title for add button"), style: .done, target: self, action: #selector(addButton(sender:)))
    }
    
    //
    // MARK: - Setting Views
    //All UIviews are implement here, all the constarits of the views are implement in the method as well
    //
    func setupViews() {
        
        view.backgroundColor = UIColor.white
        
        let tableView: UITableView = {
            let table = UITableView(frame: CGRect.init(), style: .grouped)
            table.translatesAutoresizingMaskIntoConstraints = false
            table.delegate = self
            table.dataSource = self
            table.isScrollEnabled = false
            table.allowsSelection = false
            return table
        }()
        
        view.addSubview(tableView)
        self.tableView = tableView
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0":tableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: .init(), metrics: nil, views: ["v0":tableView]))
    }

}

// MARK: - TableView Delegate and DataSource methods
extension AddCategoryPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            fatalError("There is an error somewhere...")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // MARK: Setup Views for TableView cells
        // Setup TextField
        let textField: UITextField = {
            let field = UITextField()
            field.placeholder = NSLocalizedString("Category name", comment: "Placeholder for category name")
            field.translatesAutoresizingMaskIntoConstraints = false
            field.delegate = self
            field.tag = 11
            field.clearButtonMode = .whileEditing
            return field
        }()
        
        // Setup Collection view
        // Setup it's Layout
        let collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 80, height: 80)
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            return layout
        }()
        // Setup it's view
        let collectionView: UICollectionView = {
            let view = UICollectionView(frame: CGRect.init(), collectionViewLayout: collectionViewLayout)
            view.collectionViewLayout = collectionViewLayout
            view.delegate = self
            view.translatesAutoresizingMaskIntoConstraints = false
            view.dataSource = self
            view.allowsMultipleSelection = false
            view.register(IconCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
            view.backgroundColor = UIColor.white
            return view
        }()
        
        // MARK: Setup TableView Cells
        let textFieldCell: UITableViewCell = {
            let cell = UITableViewCell()
            cell.addSubview(textField)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": textField]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": textField]))
            return cell
        }()
        
        let collectionViewCell: UITableViewCell = {
            let cell = UITableViewCell()
            cell.addSubview(collectionView)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": collectionView]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(300)]|", options: .init(), metrics: nil, views: ["v0": collectionView]))
            return cell
        }()
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return textFieldCell
            default: fatalError()
            }
        case 1:
            switch indexPath.row {
            case 0:
                return collectionViewCell
            default: fatalError()
            }
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("Type a category name", comment: "Tips for textfields")
        case 1:
            return NSLocalizedString("Choose an icon", comment: "Choose an icon for your category")
        default:
            fatalError()
        }
    }
    
}

// MARK: Collection View Delegate and DataSource methods
extension AddCategoryPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? IconCollectionViewCell
        cell?.imageView.image = UIImage(named: categoriesIcons[indexPath.row])
        cell?.layer.cornerRadius = 8
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let cell = cell {
            cell.backgroundColor = AppDesingHelper().mainColor
            icon = categoriesIcons[indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let cell = cell {
            cell.backgroundColor = UIColor.white
        }
    }
    
}

// MARK: TextField Delegate methods
extension AddCategoryPageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
