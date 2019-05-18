//
//  AddExpenseTableViewController.swift
//  Countthem
//
//  Created by Accurate on 18/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

class AddExpenseTableViewController: UITableViewController {
    
    var category: Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Add Expense"
        
        tableView = UITableView.init(frame: CGRect.init(), style: .grouped)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        
        //Showing category cell
        let categoryImage: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        let categoryName: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
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
        // TODO: Закончить ячейки
        // TODO: Протестировать фичу
        // TODO: Задокументировать фичу
        // TODO: Залить в ветку
        switch indexPath.section {
        case 0:
            return chosenCategoryCell // The showing category cell
        case 1: return UITableViewCell() // The inserting Expense name cell
        case 2: return UITableViewCell()
        case 3: return UITableViewCell()
        default: return UITableViewCell()
        }

        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
