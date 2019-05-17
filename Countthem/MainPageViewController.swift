//
//  ViewController.swift
//  Countthem
//
//  Created by Accurate on 09/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        categories = CategoriesHelper().getCategories()
        
        setupNavigationBar()
        tabBarController?.tabBar.tintColor = UIColor.purple
        
        setupViews()
    }
    
    func setupNavigationBar() {
        self.title = "Today: $34"
        guard let navBar = navigationController?.navigationBar else {return}
        navBar.prefersLargeTitles = true
        navBar.isTranslucent = false
        
    }
    
    func setupViews() {
        
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
            return collection
        }()
        
        // MARK: Table View
        let tableView: UITableView = {
            let table = UITableView()
            table.dataSource = self
            table.delegate = self
            table.register(ExpenseTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
            table.translatesAutoresizingMaskIntoConstraints = false
            return table
        }()
        
        
        
        
        // MARK: Adding views and constraits
        self.view.addSubview(myCollectionView)
        self.view.addSubview(tableView)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": myCollectionView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": tableView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(100)]-[v1]|", options: .init(), metrics: nil, views: ["v0": myCollectionView, "v1": tableView]))
    }


}

// MARK: Collection View Methods
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
        cell.layer.shadowColor = UIColor.purple.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = .init(width: 1, height: 3)
        cell.layer.shadowRadius = 1
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 0.1
        cell.layer.borderColor = UIColor.purple.cgColor
        
        return cell
    }
    
    
}

// MARK: TableView Methods
extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? ExpenseTableViewCell
        
        guard let expense = cell else {
            print("The cell is nil")
            return UITableViewCell()
        }
        print("Items have been loaded")
        
        return expense
    }
    
    
}
