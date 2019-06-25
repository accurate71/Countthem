//
//  ViewController.swift
//  Countthem
//
//  Created by Accurate on 13/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit
import MessageUI

enum Error {
    case sendMessageError
}

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
            table.backgroundColor = appDesignHelper.backgroundColor
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let categoryLabel: UILabel = {
            let label = UILabel()
            label.text = NSLocalizedString("Categories", comment: "Category option")
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let currencyLabel: UILabel = {
            let label = UILabel()
            label.text = NSLocalizedString("Currency", comment: "Currency option")
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
        
        let rateAppLabel: UILabel = {
            let label = UILabel()
            label.text = NSLocalizedString("Rate the App", comment: "Rate the App")
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let reportBugLabel: UILabel = {
            let label = UILabel()
            label.text = NSLocalizedString("Report a bug", comment: "User can report about the app")
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let categoryCell: UITableViewCell = {
            return createCell(label: categoryLabel, accessoryType: .disclosureIndicator)
        }()
        categoryCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCategoryView(sender:))))
        
        let currencyCell = UITableViewCell()
        currencyCell.accessoryType = .disclosureIndicator
        currencyCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCurrencyView(sender:))))
        currencyCell.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: currencyCell.leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: currencyCell.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: currencyCell.trailingAnchor, constant: -35)
            ])
        let rateAppCell: UITableViewCell = {
            return createCell(label: rateAppLabel, accessoryType: .disclosureIndicator)
        }()
        rateAppCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(writeReview(sender:))))
        
        let reportBugCell: UITableViewCell = {
            return createCell(label: reportBugLabel, accessoryType: .disclosureIndicator)
        }()
        reportBugCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SettingsPageViewController.sendReport)))
        
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
            case 0: return rateAppCell
            default: fatalError()
            }
        case 3:
            switch indexPath.row {
            case 0: return reportBugCell
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
        case 2: return NSLocalizedString("Like the app? Let me know", comment: "Rate the app")
        case 3: return NSLocalizedString("Found a bug? Let me know", comment: "I wanna fix them")
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
    
    @objc func writeReview(sender: UITableViewCell) {
        let productURL = URL(string: "https://itunes.apple.com/app/id958625272")! //TODO: - Change url after connecting App Store Connect

        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]

        guard let writeReviewURL = components?.url else {
            return
        }

        UIApplication.shared.open(writeReviewURL)
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

extension SettingsPageViewController: MFMailComposeViewControllerDelegate {
    @objc func sendReport() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["pushkarskiykirill@gmail.com"])
            mail.setSubject("Bug Report")
            
            present(mail, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(
                title: NSLocalizedString("No Mail Accounts", comment: "Error title"),
                message: NSLocalizedString("Please, set up a Mail account in order to sent email.", comment: "Error message"),
                preferredStyle: .alert)
            let okButton = UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil)
            alertController.addAction(okButton)
            self.present(alertController,
                         animated: true,
                         completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

