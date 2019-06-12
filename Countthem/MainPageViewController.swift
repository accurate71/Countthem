//
//  ViewController.swift
//  Countthem
//
//  Created by Accurate on 09/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    
    // MARK: - Helpers
    let appDesignHelper = AppDesingHelper()
    let appAnimationHelper = AppAnimationHelper()
    var categoriesHelper = CategoriesHelper()
    var expensesHelper = ExpensesHelper()
    let currencyHelper = CurrencyHelper()
    
    // Variables
    
    var categories = [Category]()
    var expenses = [Expense]()
    var tableView = UITableView()
    var index = Int()
    var listEmpty = false
    var total: Double?
    var currentSign: String?
    
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentSign = currencyHelper.getCurrentSign()
        
        categories = categoriesHelper.getCategories()
        print("\(categories.count)")
        expenses = expensesHelper.getExpensesWithDate(date: currentDate)
        print("\(expenses.count)")
        total = expensesHelper.getTotal(arr: expenses)
        setupNavigationBar()
        tabBarController?.tabBar.tintColor = appDesignHelper.mainColor
        
        setupViews()
    }
    
    func setupNavigationBar() {
        setTitle()
        guard let navBar = navigationController?.navigationBar else {return}
        navBar.isTranslucent = false
        navBar.barTintColor = appDesignHelper.mainColor
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func setTitle() {
        self.title = "Today: \(currentSign!)\(total ?? 0.0)"
    }
    // MARK: - Setting views
    func setupViews() {
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = false
        self.view.backgroundColor = UIColor.lightGray
        
        // MARK: Collection View
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 80, height: 80)
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            return layout
        }()
        
        
        let myCollectionView:UICollectionView = {
            let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120), collectionViewLayout: layout)
            collection.dataSource = self
            collection.delegate = self
            collection.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
            collection.backgroundColor = UIColor.white
            collection.translatesAutoresizingMaskIntoConstraints = false
            collection.isScrollEnabled = true
            collection.showsHorizontalScrollIndicator = false
            
            return collection
        }()
        
        // MARK: Table View
        let tableView: UITableView = {
            let table = UITableView()
            table.dataSource = self
            table.delegate = self
            table.backgroundColor = UIColor.init(hexString: appDesignHelper.backgroundColor)
            table.register(ExpenseTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
            table.translatesAutoresizingMaskIntoConstraints = false
            table.separatorStyle = .none
            table.allowsSelection = false
            return table
        }()
        self.tableView = tableView
        
        // MARK: Separater View
        let separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.purple
            view.translatesAutoresizingMaskIntoConstraints = false
            view.alpha = 0.2
            return view
        }()
        
        // MARK: messageView
        let messageView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor.white
            return view
        }()
        let messageLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Empty"
            label.textColor = appDesignHelper.mainColor
            label.textAlignment = .center
            label.font = label.font.withSize(32)
            return label
        }()
        let messageImage: UIImageView = {
            let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            view.translatesAutoresizingMaskIntoConstraints = false
            view.alpha = 0.5
            view.image = UIImage(named: "empty_icon")
            return view
        }()
        
        let stack: UIStackView = {
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(messageLabel)
            stack.addArrangedSubview(messageImage)
            stack.axis = .vertical
            stack.distribution = .equalSpacing
            stack.spacing = 16
            return stack
        }()
        messageImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        messageImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        messageView.addSubview(stack)
        stack.widthAnchor.constraint(equalToConstant: 100).isActive = true
        stack.centerXAnchor.constraint(equalTo: messageView.centerXAnchor, constant: 0).isActive = true
        stack.centerYAnchor.constraint(equalTo: messageView.centerYAnchor, constant: 0).isActive = true
        // MARK: Adding views and constraits
        self.view.addSubview(myCollectionView)
        self.view.addSubview(separatorView)
        // FIXME: - The problem is if an user deletes the last item, the view didn't change background and the lable isn't visible
        if expenses.isEmpty {
            print("The expenses array is empty")
            self.view.addSubview(messageView)
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": myCollectionView]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": messageView]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": separatorView]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(100)][v1(0.5)][v2]|", options: .init(), metrics: nil, views: ["v0": myCollectionView, "v1": separatorView, "v2": messageView]))
        } else {
            print("The expenses array isn't empty")
            self.view.addSubview(tableView)
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": myCollectionView]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": tableView]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": separatorView]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(100)][v1(0.5)][v2]|", options: .init(), metrics: nil, views: ["v0": myCollectionView, "v1": separatorView, "v2": tableView]))
        }
        
    }


}

// MARK: - Collection View Methods
extension MainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Define a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CategoryCollectionViewCell
        //Take an icon and a name from Array
        let categoryImage = categories[indexPath.row].icon ?? "dinner"
        let categoryName = categories[indexPath.row].name ?? "no cat"
        //Setup the cell
        cell.nameCategoryLabel.textColor = UIColor.purple
        cell.imageView.image = UIImage(named: categoryImage)
        cell.nameCategoryLabel.text = categoryName
        cell.backgroundColor = UIColor.white
        cell.layer.shadowColor = UIColor.init(hexString: appDesignHelper.backgroundColor).cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = .init(width: 1, height: 3)
        cell.layer.shadowRadius = 1
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 0.1
        cell.layer.borderColor = UIColor.gray.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3, animations: {
            cell?.backgroundColor = self.appDesignHelper.mainColor.withAlphaComponent(0.3)
            cell?.center.y += 5
        }) { _ in
            let category = self.categories[indexPath.row]
            let addExpenseViewController = AddExpenseTableViewController()
            addExpenseViewController.category = category
            self.navigationController?.pushViewController(addExpenseViewController, animated: true)
        }
        
    }
    
    
}

// MARK: - TableView Methods
extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? ExpenseTableViewCell
        
        guard let expense = cell else {
            print("The cell is nil")
            return UITableViewCell()
        }
        guard let category = expenses[indexPath.row].category else { print("The category of the expense is nil"); return UITableViewCell()}
        expense.categoryImage.image = UIImage(named: category.icon!)
        expense.nameCategory.text = category.name!
        expense.nameExpense.text = expenses[indexPath.row].name
        expense.expensePrice.text = "\(currentSign!)\(expenses[indexPath.row].price)"
        
        
        return expense
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            self.expensesHelper.removeExpenses(expense: self.expenses[indexPath.row])
            self.expenses.remove(at: indexPath.row)
            tableView.reloadData()
            self.total = self.expensesHelper.getTotal(arr: self.expenses)
            self.setTitle()
            AppAnimationHelper().animationDeleting(for: tableView)
        }
        deleteAction.backgroundColor = appDesignHelper.mainColor
        
        return [deleteAction]
    }
}
