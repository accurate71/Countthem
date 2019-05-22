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
    let appDesignHelper = AppDesingHelper()
    var debtsNames: [Debt] = [Debt(name: "David", money: "$34", date: "22/05/19"),
                              Debt(name: "Alex", money: "$24", date: "22.05.19"),
                              Debt(name: "Moon", money: "$34", date: "22/05/19"),
                              Debt(name: "David", money: "$34", date: "22.05.19")]

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navbar = navigationController?.navigationBar {
            setupNavBar(navbar)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
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
            cell.nameLabel.text = debtsNames[indexPath.row].name!
            cell.priceLabel.text = debtsNames[indexPath.row].money!
            cell.dateLabel.text = debtsNames[indexPath.row].date!
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}

// MARK: Setup Navigation Bar
extension DebtBookController {
    
    func setupNavBar(_ navbar:UINavigationBar){
        navbar.barTintColor = UIColor.init(hexString: appDesignHelper.mainColor)
        navbar.tintColor = UIColor.white
        navbar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navbar.prefersLargeTitles = false
        navbar.isTranslucent = false
        title = "Debt Book"
    }
    
}

