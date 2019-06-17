//
//  ViewController.swift
//  Countthem
//
//  Created by Accurate on 13/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

class SettingsPageViewController: UIViewController {
    
    let currencyHelper = CurrencyHelper()
    let appDesignHelper = AppDesingHelper()
    
    var currentSign: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentSign = currencyHelper.getCurrentSign()
        setupTabbar()
        setupViews()
        setupNavigationBar()
        
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupNavigationBar() {
        let titleString = NSLocalizedString("Settings", comment: "The title of settings page")
        self.title = titleString
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = appDesignHelper.mainColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    // MARK: Setup Views Method
    func setupViews() {
        //Table View
        let menuTable: UITableView = {
            let table = UITableView(frame: CGRect.init(), style: .grouped)
            table.delegate = self
            table.dataSource = self
            table.translatesAutoresizingMaskIntoConstraints = false
            table.isScrollEnabled = false
            table.backgroundColor = UIColor.init(hexString: appDesignHelper.backgroundColor)
            return table
        }()
        
//        let logOutButton: UIButton = {
//            let button = UIButton()
//            button.setTitle("Log Out", for: .normal)
//            return button
//        }()
        
        self.view.addSubview(menuTable)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0":menuTable]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: .init(), metrics: nil, views: ["v0":menuTable]))
    }
    

}

// MARK: Table View Protocols
extension SettingsPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let categoryLabel: UILabel = {
            let label = UILabel()
            let labelString = NSLocalizedString("Categories", comment: "Category option")
            label.text = labelString
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let currencyLabel: UILabel = {
            let label = UILabel()
            let labelString = NSLocalizedString("Currency", comment: "Currency option")
            label.text = labelString
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let currentCurrency: UILabel = {
            let label = UILabel()
            label.text = currencyHelper.getCurrentSign()
            label.textColor = .lightGray
            label.textAlignment = .right
            return label
        }()
        
        let stackView = UIStackView(arrangedSubviews: [currencyLabel, currentCurrency])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let aboutLabel: UILabel = {
            let label = UILabel()
            let labelString = NSLocalizedString("About", comment: "About the app")
            label.text = labelString
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let categoryCell: UITableViewCell = {
            return createCell(label: categoryLabel, accessoryType: .disclosureIndicator)
        }()
        categoryCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCategoryView(sender:))))
        
        let testCell = UITableViewCell()
        testCell.accessoryType = .disclosureIndicator
        testCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCurrencyView(sender:))))
        testCell.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: testCell.leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: testCell.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: testCell.trailingAnchor, constant: -35)
            ])
        let aboutCell: UITableViewCell = {
            return createCell(label: aboutLabel, accessoryType: .disclosureIndicator)
        }()
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return categoryCell
            default: fatalError("Unknown error")
            }
        case 1:
            switch indexPath.row {
            case 0: return testCell
            default: fatalError()
            }
        case 2:
            switch indexPath.row {
            case 0: return aboutCell
            default: fatalError()
            }
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return NSLocalizedString("Create and manage your categories", comment: "Category description")
        case 1: return NSLocalizedString("Manage Currency", comment: "Currency description")
        case 2: return NSLocalizedString("Learn more about the app", comment: "Learn more about us")
        default:
            fatalError()
        }
    }
    
    @objc func openCategoryView(sender: UITableViewCell) {
        self.navigationController?.pushViewController(CategoriesViewController.init(), animated: true)
    }
    
    @objc func openCurrencyView(sender: UITableViewCell) {
        if let currentSign = currentSign {
            let vc = CurrencyViewController()
            vc.currentSign = currentSign
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func createCell(label: UILabel, accessoryType: UITableViewCell.AccessoryType) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = accessoryType
        cell.addSubview(label)
        cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]|", options: .init(), metrics: nil, views: ["v0": label]))
        cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": label]))
        return cell
    }
    
    
}

// MARK: - Setup Tabbar
extension SettingsPageViewController {
    func setupTabbar() {
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = true
    }
}
