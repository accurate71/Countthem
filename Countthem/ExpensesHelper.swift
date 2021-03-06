//
//  ExpensesHelper.swift
//  Countthem
//
//  Created by Accurate on 18/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

/*
 The class is a manager of Expenses. All the methods of Data Base which are wired with expenses are located here.
 The manager can save, delete, add, load categories.
 */

import Foundation
import CoreData
import UIKit.UIApplication

class ExpensesHelper {
    
    var expenses = [Expense]()
    
    let fetchRequest =
        NSFetchRequest<Expense>(entityName: "Expense")
    
    // MARK: - Add category method
    func addExpense(name: String, price: Double, date: NSDate, category: Category) {
        let entity = NSEntityDescription.entity(forEntityName: "Expense", in: getContext())
        let expense = Expense(entity: entity!, insertInto: getContext())
        expense.setValue(name, forKey: "name")
        expense.setValue(price, forKey: "price")
        expense.setValue(date, forKey: "date")
        expense.setValue(category, forKey: "category")
        saveExpenses()
        expenses.append(expense)
    }
    
    // MARK: - Load Categories
    private func loadExpenses() {
        //3
        do {
            expenses = try getContext().fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func loadExpensesWithDate(date: Date) -> [Expense] {
        loadExpenses()
        var arrayToReturn = [Expense]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        for element in expenses {
            let checkingdate1 = dateFormatter.string(from: element.date!)
            let checkingdate2 = dateFormatter.string(from: date)
            if checkingdate1 == checkingdate2 {
                arrayToReturn.append(element)
            }
        }
        return arrayToReturn
    }
    
    // MARK: - Remove category Method
    func removeExpenses(expense: Expense) {
        do {
            expenses = getExpenses()
            getContext().delete(expense)
            saveExpenses()
        }
    }
    
    // MARK: - Save categories
    func saveExpenses() {
        do {
            try getContext().save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType) }
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }
    
    func getExpenses() -> [Expense] {
        loadExpenses()
        return expenses
    }
    
    func getTotal(arr: [Expense]) -> Double {
        var total = Double()
        for expense in arr {
            total += expense.price
        }
        return total
    }
    
    func getExpensesWithDate(date: Date) -> [Expense] {
        return loadExpensesWithDate(date: date)
    }
}
