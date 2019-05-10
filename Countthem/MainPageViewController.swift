//
//  ViewController.swift
//  Countthem
//
//  Created by Accurate on 09/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge.bottom
        extendedLayoutIncludesOpaqueBars = true
        
        setupNavigationBar()
        
        setupViews()
        
    }
    
    func setupNavigationBar() {
        
        self.title = "Main"
        navigationController?.navigationItem.title = "Main"
    }
    
    func setupViews() {
        
        // MARK: Collection View
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: 100, height: 100)
            layout.scrollDirection = .horizontal
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
        
        
        
        
        // MARK: Adding views and constraits
        self.view.addSubview(myCollectionView)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": myCollectionView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(100)]|", options: .init(), metrics: nil, views: ["v0": myCollectionView]))
    }


}

extension MainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CategoryCollectionViewCell
        
        return cell
    }
    
    
}

