//
//  StatsTableViewCell.swift
//  Countthem
//
//  Created by Accurate on 31/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {
    
    let totalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.font = label.font.withSize(17)
        label.textAlignment = .right
        label.alpha = 0.8
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let totalMoneyLabel: UILabel = {
        let label = UILabel()
        label.text = "$132"
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = UIStackView.Distribution.fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    let categoryIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let categoryName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        stackView.addArrangedSubview(totalTitleLabel)
        stackView.addArrangedSubview(totalMoneyLabel)
        addSubview(categoryIcon)
        addSubview(categoryName)
        addSubview(stackView)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0(50)]-16-[v1]-[v2]-|", options: .alignAllCenterY, metrics: nil, views: ["v0": categoryIcon, "v1": categoryName, "v2": stackView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0(50)]-|", options: .init(), metrics: nil, views: ["v0": categoryIcon]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": categoryName]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: .init(), metrics: nil, views: ["v0": stackView]))
        
        
    }

}
