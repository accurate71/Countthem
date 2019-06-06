//
//  CurrencyViewController.swift
//  Countthem
//
//  Created by Accurate on 05/06/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    // MARK: - Helpers
    let currencyHelper = CurrencyHelper()
    let designHelper = AppDesingHelper()
    
    // MARK: - Variables
    var currentSign: String?
    var currencyArray = [String]()
    
    // MARK: - Views
    let signSwitcher = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: 210, height: 50))
    let converterLabel = UILabel()
    let leftTF = UITextField()
    let rightTF = UITextField()
    let stackView = UIStackView()
    let currencyPicker = UIPickerView()
    let amountTextField = UITextField()
    let valueLabel = UILabel()
    let convertButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        currencyArray = [currencyHelper.dollar, currencyHelper.ruble, currencyHelper.euro]
        
        setupNavigationBar()
        setupTabbar()
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Setup views method
    func setupViews() {
        // MARK: Setting views
        // Sign Switcher
        signSwitcher.tintColor = designHelper.mainColor
        signSwitcher.insertSegment(withTitle: "$", at: 0, animated: true)
        signSwitcher.insertSegment(withTitle: "₽", at: 1, animated: true)
        signSwitcher.insertSegment(withTitle: "€", at: 2, animated: true)
        signSwitcher.addTarget(self, action: #selector(segmentedControllAction(_:)), for: .valueChanged)
        signSwitcher.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)], for: .normal)
        signSwitcher.selectedSegmentIndex = getSelectedIndex()
        // Converter label
        converterLabel.text = "Converter"
        converterLabel.font = UIFont.boldSystemFont(ofSize: 20)
        converterLabel.textAlignment = .center
        // Text fields and their stackview
        leftTF.placeholder = "from"
        leftTF.borderStyle = .roundedRect
        leftTF.textAlignment = .center
        leftTF.inputView = currencyPicker
        rightTF.placeholder = "to"
        rightTF.borderStyle = .roundedRect
        rightTF.textAlignment = .center
        rightTF.inputView = currencyPicker
        stackView.addArrangedSubview(leftTF)
        stackView.addArrangedSubview(rightTF)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.setCustomSpacing(16, after: leftTF)
        // Currency Picker
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        // Amount TextField
        amountTextField.placeholder = "Type amount"
        amountTextField.keyboardType = .decimalPad
        amountTextField.borderStyle = .roundedRect
        amountTextField.textAlignment = .center
        amountTextField.clearButtonMode = .whileEditing
        // Value Label
        valueLabel.isHidden = false
        valueLabel.font = UIFont.boldSystemFont(ofSize: 50)
        valueLabel.textAlignment = .center
        valueLabel.text = "0"
        valueLabel.adjustsFontSizeToFitWidth = true
        // Convert Button
        convertButton.setTitle("Convert", for: .normal)
        convertButton.layer.cornerRadius = 8
        convertButton.backgroundColor = designHelper.mainColor
        convertButton.addTarget(self, action: #selector(convert(sender:)), for: .touchDown)
        
        // MARK: Adding Subviews
        setForAutoLayout(views: [signSwitcher, converterLabel, stackView, amountTextField, valueLabel, convertButton])
        view.addSubview(signSwitcher)
        view.addSubview(converterLabel)
        view.addSubview(stackView)
        view.addSubview(amountTextField)
        view.addSubview(valueLabel)
        view.addSubview(convertButton)
        
        // MARK: AutoLayout
        NSLayoutConstraint.activate([
            signSwitcher.widthAnchor.constraint(equalToConstant: 210),
            signSwitcher.heightAnchor.constraint(equalToConstant: 50),
            signSwitcher.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signSwitcher.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32),
            converterLabel.topAnchor.constraint(equalTo: signSwitcher.bottomAnchor, constant: 32),
            converterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            converterLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 40),
            stackView.topAnchor.constraint(equalTo: converterLabel.bottomAnchor, constant: 28),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            amountTextField.widthAnchor.constraint(equalToConstant: 120),
            amountTextField.heightAnchor.constraint(equalToConstant: 40),
            amountTextField.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            amountTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 50),
            valueLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            convertButton.heightAnchor.constraint(equalToConstant: 50),
            convertButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            convertButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            convertButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            ])
    }
    
    func setForAutoLayout(views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }

}

// MARK: - Setup Navigation Bar
extension CurrencyViewController {
    func setupNavigationBar(){
        title = "Currency"
    }
}

// MARK: - Setup Tabbar
extension CurrencyViewController {
    func setupTabbar() {
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
}

// MARK: -  Segmented control methods
extension CurrencyViewController {
    
    @objc func segmentedControllAction(_ segmentedControll: UISegmentedControl) {
        switch segmentedControll.selectedSegmentIndex {
        case 0:
            currencyHelper.setCurrentSign(with: "$")
        case 1:
            currencyHelper.setCurrentSign(with: "₽")
        case 2:
            currencyHelper.setCurrentSign(with: "€")
        default:
            fatalError()
        }
    }
    
    func getSelectedIndex() -> Int {
        if let currentSign = currentSign {
            switch currentSign {
            case "$": return 0
            case "₽": return 1
            case "€": return 2
            default: return 3
            }
        } else {
            return 3
        }
    }
    
}

// MARK: - Picker view methods
extension CurrencyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if leftTF.isEditing {
            leftTF.text = currencyArray[row]
            view.endEditing(true)
        } else if rightTF.isEditing {
            rightTF.text = currencyArray[row]
            view.endEditing(true)
        }
    }
    
}

// MARK: - Converter Button Action
extension CurrencyViewController {
    
    @objc func convert(sender: UIButton) {
        let viewBack = UIView(frame: self.view.bounds)
        viewBack.backgroundColor = .black
        viewBack.alpha = 0
        
        if let from = leftTF.text,
            let to = rightTF.text,
            let value = amountTextField.text {
            currencyHelper.getValue(from: from, to: to, with: value)
            self.view.addSubview(viewBack)
            UIView.animate(withDuration: 0.3) {
                viewBack.alpha = 0.5
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                UIView.animate(withDuration: 0.5) {
                    viewBack.alpha = 0
                }
                self.valueLabel.text = self.currencyHelper.getAfterCountingValue()
            }
        }
    }
}
