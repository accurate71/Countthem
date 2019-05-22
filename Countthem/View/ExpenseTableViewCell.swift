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
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameExpense: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.text = "Expense"
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let expensePrice: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "$0.5"
        return label
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.text = "Today"
        label.textColor = UIColor.init(hexString: AppDesingHelper().dateColor)
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
    
    func setupViews(){
        self.backgroundColor = UIColor.clear
        //making stack views
        let firstInfo: UIStackView = {
            let view = UIStackView(arrangedSubviews: [nameCategory,nameExpense])
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .vertical
            return view
        }()
        
        let mainView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 8
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        //adding views
        mainView.addSubview(categoryImage)
        mainView.addSubview(firstInfo)
        mainView.addSubview(expensePrice)
        //adding constraits
        //horizontal
        mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(35)]-16-[v1][v2]-16-|", options: .init(), metrics: nil, views: ["v0": categoryImage, "v1": firstInfo, "v2": expensePrice]))
        //vertical
        mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0(35)]-16-|", options: .init(), metrics: nil, views: ["v0": categoryImage]))
        mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: .init(), metrics: nil, views: ["v0": firstInfo]))
        mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": expensePrice]))
        addSubview(date)
        addSubview(mainView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": date]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": mainView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-4-[v1]|", options: .init(), metrics: nil, views: ["v0": date, "v1":mainView]))
        
    }

}
