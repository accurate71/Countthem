//
//  CategoriesViewController.swift
//  Countthem
//
//  Created by Accurate on 13/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.

import UIKit
import QuartzCore

class CategoriesViewController: UIViewController {
    
    var categories = [Category]()
    
    // MARK: - Helpers
    let categoryHelper = CategoriesHelper()
    let appDesingHelper = AppDesingHelper()
    let appAnimationHelper = AppAnimationHelper()
    
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
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetching categories
        categories = categoryHelper.getCategories()
        
        // Setup Tabbar
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
        
        setupViews()
    }
    
    // MARK: Right Bar Button Action
    /*
     The category will be added by the method
     */
    @objc func addCategory(sender: UIBarButtonItem!) {
        self.navigationController?.pushViewController(AddCategoryPageViewController.init(), animated: true)
    }
    
    // MARK: - Setup Nav Bar method
    func setupNavigationBar() {
        title = NSLocalizedString("Categories", comment: "The title of Categories screen")
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategory(sender:))), animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    //
    // MARK: Setup View Method
    //
    //
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
            collection.backgroundColor = appDesingHelper.backgroundColor
            collection.translatesAutoresizingMaskIntoConstraints = false
            collection.isScrollEnabled = true
            collection.allowsSelection = true
            collection.allowsMultipleSelection = false
            return collection
        }()
        // Adding the collection view to the superview
        view.addSubview(collectionView)
        self.collectionView = collectionView
        // Adding constraits
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": collectionView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: .init(), metrics: nil, views: ["v0": collectionView]))
    }

}

// MARK: - Collection View Methods
/*
 */
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
            cell.layer.shadowColor = appDesingHelper.mainColor.cgColor
            cell.layer.shadowOpacity = 1
            cell.layer.shadowOffset = .init(width: 0, height: 0)
            cell.layer.shadowRadius = 2
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        showActionMenu(for: cell, with: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        deleteButton.removeFromSuperview()
        backgroundView.removeFromSuperview()
    }
    
    /*
     This method open a menu with the delete button.
     It takes the cell and it's index to delete the category from Database
     and the array which are in the top of the file.
    */
    func showActionMenu(for cell: UICollectionViewCell, with index: Int) {
        //Controller
        let actionViewController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // Titles
        let deleteTitle = NSLocalizedString("Delete", comment: "The delete button")
        let cancelTitle = NSLocalizedString("Cancel", comment: "the cancel button")
        // Actions
        let deleteButton = UIAlertAction(title: deleteTitle, style: .destructive) { (action) in
            // delete cell code
            print("Delete button tapped")
            if let collection = self.collectionView {
                
                // Ask CategoriesHelper for a help
                self.categoryHelper.removeCategory(category: self.categories[index])
                
                // Remove a deleted category from a collection
                self.categories.remove(at: index)
                collection.reloadData()
                
                // Setup an animation
                AppAnimationHelper().animationDeleting(for: collection)
                
            }
        }
        let cancelButton = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        actionViewController.addAction(deleteButton)
        actionViewController.addAction(cancelButton)
        // Add some animations, make the screen be live.
        appAnimationHelper.clickButton(view: cell,
                                       color1: appDesingHelper.mainColor,
                                       color2: UIColor.white) {
                                        self.present(actionViewController, animated: true, completion: nil)
        }
        
    }
    
    
}
