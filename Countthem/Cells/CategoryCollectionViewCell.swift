//
//  CategoryCollectionViewCell.swift
//  Countthem
//
//  Created by Accurate on 10/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        let imageView: UIImageView = {
            let view = UIImageView()
            view.backgroundColor = UIColor.blue
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let nameCategoryLabel: UILabel = {
            let label = UILabel()
            label.text = "Category"
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font.withSize(12)
            label.textColor = UIColor.blue
            label.textAlignment = .center
            return label
        }()
        
        addSubview(imageView)
        addSubview(nameCategoryLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0(44)]-|", options: .init(), metrics: nil, views: ["v0": imageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": nameCategoryLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0(44)]-8-[v1]-16-|", options: .init(), metrics: nil, views: ["v0": imageView, "v1": nameCategoryLabel]))
    }
    
}
