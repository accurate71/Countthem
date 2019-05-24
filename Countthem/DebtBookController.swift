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

class DebtBookController: UITableViewController {
    
    @IBOutlet weak var debtCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let appDesignHelper = AppDesingHelper()
    var debtsNames: [Debt] = [Debt(name: "David", money: "$34", date: "22/05/19"),
                              Debt(name: "Alex", money: "$24", date: "22.05.19"),
                              Debt(name: "Moon", money: "$34", date: "22/05/19"),
                              Debt(name: "David", money: "$34", date: "22.05.19")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        debtCollectionView.backgroundColor = UIColor(hexString: appDesignHelper.backgroundColor)
        tableView.backgroundColor = UIColor(hexString: appDesignHelper.backgroundColor)

        if let navbar = navigationController?.navigationBar {
            setupNavBar(navbar)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.init(hexString: appDesignHelper.backgroundColor)
        titleLabel.textColor = appDesignHelper.anotherColor
    }
    

}

// MARK: Collection View Protocols
extension DebtBookController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return debtsNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = debtCollectionView.dequeueReusableCell(withReuseIdentifier: "DebtCell", for: indexPath) as? Debt_DebtorsCollectionViewCell
        
        if let cell = cell {
            decorateCell(cell)
            cell.nameLabel.text = debtsNames[indexPath.row].name!
            cell.nameLabel.textColor = appDesignHelper.mainColor
            cell.priceLabel.text = debtsNames[indexPath.row].money!
            cell.dateLabel.text = debtsNames[indexPath.row].date!
            cell.dateLabel.textColor = UIColor.gray
            return cell
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

