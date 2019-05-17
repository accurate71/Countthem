//
//  ExpenseTableViewCell.swift
//  Countthem
//
//  Created by Accurate on 12/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {
    
    //setting views
    let categoryImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = UIView.ContentMode.scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "bus")
        return view
    }()
    
    let nameCategory: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.text = "Category"
        label.font = label.font.withSize(17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameExpense: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.text = "Expense"
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let expensePrice: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(17)
        label.text = "$0.5"
        return label
    }()
    
    let data: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.text = "Today"
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupViews(){
        
        //making stack views
        let firstInfo: UIStackView = {
            let view = UIStackView(arrangedSubviews: [nameCategory,nameExpense])
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setCustomSpacing(4, after: nameCategory)
            view.axis = .vertical
            return view
        }()
        
        let secondInfo: UIStackView = {
            let view = UIStackView(arrangedSubviews: [data, expensePrice])
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setCustomSpacing(8, after: data)
            view.axis = .vertical
            return view
        }()
        //adding views
        addSubview(categoryImage)
        addSubview(firstInfo)
        addSubview(secondInfo)
        //adding constraits
        //horizontal
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0(40)]-16-[v1][v2]-|", options: .init(), metrics: nil, views: ["v0": categoryImage, "v1": firstInfo, "v2": secondInfo]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: .init(), metrics: nil, views: ["v0": firstInfo]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]-16-|", options: .init(), metrics: nil, views: ["v0": imageView]))
        //vertical
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0(40)]-16-|", options: .init(), metrics: nil, views: ["v0": categoryImage]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: .init(), metrics: nil, views: ["v0": firstInfo]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": secondInfo]))
        
        
    }

}
