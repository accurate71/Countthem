//
//  ViewController.swift
//  Countthem
//
//  Created by Accurate on 13/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

class SettingsPageViewController: UIViewController {
    
    let items = ["Category", "Currency", "About"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isTranslucent = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViews()
        setupNavigationBar()
        
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupNavigationBar() {
        self.title = "Settings"
        navigationController?.navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = false
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
            label.text = "Category"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let currencyLabel: UILabel = {
            let label = UILabel()
            label.text = "Currency"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let aboutLabel: UILabel = {
            let label = UILabel()
            label.text = "About"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let categoryCell: UITableViewCell = {
            return createCell(label: categoryLabel, accessoryType: .disclosureIndicator)
        }()
        let currencyCell: UITableViewCell = {
            return createCell(label: currencyLabel, accessoryType: .none)
        }()
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
            case 0: return currencyCell
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
        case 0: return "Create and manage your categories"
        case 1: return "Manage Currency"
        case 2: return "Learn mode about the app"
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(CategoriesViewController.init(), animated: true)
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
