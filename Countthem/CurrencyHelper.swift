//
//  CurrencyHelper.swift
//  Countthem
//
//  Created by Accurate on 05/06/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import Foundation
import SwiftyPlistManager
import Alamofire
import SwiftyJSON

class CurrencyHelper {
    
    let api_key = "5b98530c514c30b7290c6a1400bfa6e0"
    
    var leftField: String?
    var rightField: String?
    var value: String?
    var currentSign: String?
    
    var afterConvertingValue: String?
    
    //currency
    let ruble = "Ruble - ₽"
    let dollar = "Dollar - $"
    let euro = "Euro - €"
    
    var format = PropertyListSerialization.PropertyListFormat.xml
    var plistData:[String:String] = [:]  //our data
    let plistPath:String? = Bundle.main.path(forResource: "defaults", ofType: "plist")!
    
    func getValue(from leftField: String, to rightField: String, with value: String) {
        var from = ""
        var to = ""
        
        switch leftField {
        case ruble: from = "RUB"
        case dollar: from = "USD"
        case euro: from = "EUR"
        default: fatalError()
        }

        switch rightField {
        case ruble: to = "RUB"
        case dollar: to = "USD"
        case euro: to = "EUR"
        default: fatalError()
        }
        
        print("\(from)")
        print("\(to)")

        if from != "" && to != "" {
            Alamofire.request("https://currate.ru/api/?get=rates&pairs=\(from)\(to)&key=\(api_key)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    let currentState = swiftyJsonVar["data"]["\(from)\(to)"].floatValue
                    let counting = currentState*Float(value)!
                    self.afterConvertingValue = String("\(counting)")
                    
                }
            }
        }
        
    }
    
    func getAfterCountingValue() -> String{
        if let value = afterConvertingValue {
            return value
        } else {
            return "Something goes wrong. Try again"
        }
    }
    
    func setCurrentSign(with sign: String) {
        updatePlist(with: sign)
    }
    
    func getCurrentSign() -> String {
        return readPlist()
    }
    
    // MARK: - Plist methods
    private func readPlist() -> String {
        
        SwiftyPlistManager.shared.getValue(for: "sign", fromPlistWithName: "defaults") { (result, err) in
            if err == nil {
                currentSign = result as? String
            }
        }
        
        if let currentSign = currentSign {
            return currentSign
        } else {
            return ""
        }
        
    }
    
    private func updatePlist(with sign:String) {
        
        SwiftyPlistManager.shared.save(sign, forKey: "sign", toPlistWithName: "defaults") { (err) in
            if err == nil {
                print("Saved normally")
            }
        }
        
    }
}
