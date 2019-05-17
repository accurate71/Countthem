//
//  CategoriesViewController.swift
//  Countthem
//
//  Created by Accurate on 13/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        categories = CategoriesHelper().getCategories()
        
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupViews()
    }
    
    @objc func addCategory(sender: UIBarButtonItem!) {
        print("Add category button has been tapped")
        self.navigationController?.pushViewController(AddCategoryPageViewController.init(), animated: true)
    }
    
    func setupNavigationBar() {
        title = "Categories"
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategory(sender:))), animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.purple
    }
    
    func setupViews() {
        
        // MARK: Collection View
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 80, height: 80)
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 16, left: 8, bottom: 0, right: 8)
            return layout
        }()
        
        
        let collectionView:UICollectionView = {
            let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
            collection.dataSource = self
            collection.delegate = self
            collection.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
            collection.backgroundColor = UIColor.white
            collection.translatesAutoresizingMaskIntoConstraints = false
            collection.isScrollEnabled = true
            return collection
        }()
        
        view.addSubview(collectionView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": collectionView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: .init(), metrics: nil, views: ["v0": collectionView]))
    }

}

extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    // TODO: Сделать нормальное отображение коллекции категории
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? CategoryCollectionViewCell
        
        cell?.imageView.image = UIImage(named: categories[indexPath.row].icon ?? "dinner")
        cell?.nameCategoryLabel.text = categories[indexPath.row].name ?? "No cat"
        cell?.nameCategoryLabel.textColor = UIColor.white
        cell?.backgroundColor = UIColor.purple
        cell?.layer.cornerRadius = 8
        return cell!
    }
    
    
}
