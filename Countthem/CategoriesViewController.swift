//
//  CategoriesViewController.swift
//  Countthem
//
//  Created by Accurate on 13/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

// TODO: Изменить дизайн этого экрана, с помощью TableView

import UIKit
import QuartzCore

class CategoriesViewController: UIViewController {
    
    var categories = [Category]()
    
    // Create a view with a button
    let backgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setImage(UIImage(named: "delete"), for: .normal)
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.layer.cornerRadius = 4
        return button
    }()
    
    // The index is needed when the delete button is tapped
    var index = Int()
    var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetching categories
        categories = CategoriesHelper().getCategories()
        
        // Setup Tabbar
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
        
        setupNavigationBar()
        
        setupViews()
    }
    
    // MARK: Right Bar Button Action
    // The category will be added by the method
    @objc func addCategory(sender: UIBarButtonItem!) {
        print("Add category button has been tapped")
        self.navigationController?.pushViewController(AddCategoryPageViewController.init(), animated: true)
    }
    
    // MARK: Setup Nav Bar method
    func setupNavigationBar() {
        title = "Categories"
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategory(sender:))), animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    // MARK: Setup View Method
    func setupViews() {
        
        // Setup SuperView
        view.backgroundColor = UIColor.white
        
        // MARK: Collection View
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 80, height: 80)
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 16, left: 8, bottom: 0, right: 8)
            return layout
        }()
        
        // The collection view is needed to display all created categories
        let collectionView:UICollectionView = {
            let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
            collection.dataSource = self
            collection.delegate = self
            collection.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
            collection.backgroundColor = UIColor.white
            collection.translatesAutoresizingMaskIntoConstraints = false
            collection.isScrollEnabled = true
            collection.allowsSelection = true
            collection.allowsMultipleSelection = false
            return collection
        }()
        
        // Adding the collection view to the superview
        view.addSubview(collectionView)
        
        // ...
        self.collectionView = collectionView
        
        // Adding constraits
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": collectionView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: .init(), metrics: nil, views: ["v0": collectionView]))
    }

}

// MARK: CollectionView Protocols
extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? CategoryCollectionViewCell
        
        if let cell = cell {
            cell.imageView.image = UIImage(named: categories[indexPath.row].icon ?? "dinner")
            cell.nameCategoryLabel.text = categories[indexPath.row].name ?? "No cat"
            cell.nameCategoryLabel.textColor = UIColor.white
            cell.backgroundColor = AppDesingHelper().mainColor
            cell.layer.cornerRadius = 8
//            cell.layer.shadowColor = UIColor.purple.cgColor
//            cell.layer.shadowOpacity = 0.2
//            cell.layer.shadowOffset = .init(width: 1, height: 3)
//            cell.layer.shadowRadius = 1
//            cell.layer.cornerRadius = 8
//            cell.layer.borderWidth = 0.1
//            cell.layer.borderColor = UIColor.purple.cgColor
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        if let cell = cell {
            UIView.animate(withDuration: 0.2) {
                self.backgroundView.alpha = 0.5
                self.deleteButton.alpha = 1
            }
            
            cell.addSubview(backgroundView)
            
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeSubviews(sender:))))
            
            cell.addSubview(deleteButton)
            
            deleteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeCategory(sender:))))
            
            index = indexPath.row
            
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": backgroundView]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[v0]-25-|", options: .init(), metrics: nil, views: ["v0": deleteButton]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: .init(), metrics: nil, views: ["v0": backgroundView]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[v0]-25-|", options: .init(), metrics: nil, views: ["v0": deleteButton]))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        deleteButton.removeFromSuperview()
        backgroundView.removeFromSuperview()
    }
    
    // MARK: Remove Category Method
    // Delete a category with a small animation
    @objc func removeCategory(sender: UIButton) {
        if let collection = self.collectionView {
            
            // Ask CategoriesHelper for a help
            CategoriesHelper().removeCategory(category: categories[index])
            
            // Remove a deleted category from a collection
            categories.remove(at: index)
            collection.reloadData()
            
            // Setup an animation
            AppAnimationHelper().animationDeleting(for: collection)
            
        }
    }
    
    // The method is needed when the user want to hide the menu with the delete button which is over Collection cell
    @objc func removeSubviews(sender: UIView) {
        print("Has been tapped")
        
        if self.backgroundView.alpha == 0 && self.deleteButton.alpha == 0 {
            deleteButton.removeFromSuperview()
            backgroundView.removeFromSuperview()
        } else {
            UIView.animate(withDuration: 0.2) {
                self.backgroundView.alpha = 0
                self.deleteButton.alpha = 0
            }
        }
    }
    
    
}
