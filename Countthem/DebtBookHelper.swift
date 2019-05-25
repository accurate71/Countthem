//
//  DebtBookHelper.swift
//  Countthem
//
//  Created by Accurate on 25/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import Foundation
import CoreData
import UIKit.UIApplication

class DebtBookHelper {
    
    var debts = [Debt]()
    var debtors = [Debtor]()
    
    // MARK: Add Debt method
    func addDebt(name: String, money: Double, date: NSDate) {
        let entity = NSEntityDescription.entity(forEntityName: "Debt", in: getContext())
        let debt = Debt(entity: entity!, insertInto: getContext())
        debt.setValue(name, forKey: "name")
        debt.setValue(money, forKey: "money")
        debt.setValue(date, forKey: "date")
        save()
        debts.append(debt)
        print("Debt has been added")
    }
    
    // MARK: Add Debtor method
    func addDebtor(name: String, money: Double, date: NSDate) {
        let entity = NSEntityDescription.entity(forEntityName: "Debtor", in: getContext())
        let debtor = Debtor(entity: entity!, insertInto: getContext())
        debtor.setValue(name, forKey: "name")
        debtor.setValue(money, forKey: "money")
        debtor.setValue(date, forKey: "date")
        save()
        debtors.append(debtor)
        print("Debt has been added")
    }
    
    // MARK: Load Debts
    func load(for what: String) {
        if what == "Debt" {
            let fetchRequest =
                NSFetchRequest<Debt>(entityName: "Debt")
            
            do {
                debts = try getContext().fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        } else if what == "Debtor" {
            let fetchRequest =
                NSFetchRequest<Debtor>(entityName: "Debtor")
            
            do {
                debtors = try getContext().fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: Remove category Method
    func removeDebts(debt: Debt) {
        do {
            debts = getDebts()
            getContext().delete(debt)
            save()
        }
    }
    
    // MARK: Save categories
    func save() {
        do {
            try getContext().save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType) }
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }
    
    func getDebts() -> [Debt] {
        load(for: "Debt")
        return debts
    }
    
    func getDebtors() -> [Debtor] {
        load(for: "Debtor")
        return debtors
    }
}
