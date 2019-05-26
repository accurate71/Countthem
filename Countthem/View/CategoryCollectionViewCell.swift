//
//  CategoryCollectionViewCell.swift
//  Countthem
//
//  Created by Accurate on 10/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = UIView.ContentMode.scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "games")
        return view
    }()
    
    let nameCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.textColor = UIColor.blue
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(imageView)
        addSubview(nameCategoryLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0(40)]-20-|", options: .init(), metrics: nil, views: ["v0": imageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": nameCategoryLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0(44)]-6-[v1]-6-|", options: .init(), metrics: nil, views: ["v0": imageView, "v1": nameCategoryLabel]))
    }
    
}
