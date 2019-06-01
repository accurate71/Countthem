//
//  CategoriesHelper.swift
//  Countthem
//
//  Created by Kirill Pushkarskiy.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//
/*
 The class is a manager of Categories. All the methods of Data Base which are wired with categories are located here.
 The manager can save, delete, add, load categories.
 */
import Foundation
import UIKit
import CoreData

class CategoriesHelper {
    
    let expensesHelper = ExpensesHelper()
    
    // Creating 2 arrays which hold the items of Expenses and Categories
    var categories = [Category]()
    var expenses = [Expense]()
    
    // MARK: Add category method
    func addCategory(name: String, icon: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: getContext())
        let category = Category(entity: entity!, insertInto: getContext())
        category.setValue(name, forKey: "name")
        category.setValue(icon, forKey: "icon")
        saveCategories()
        categories.append(category)
    }
    
    // MARK: Load Categories
    func loadCategories() {
        let fetchRequest =
            NSFetchRequest<Category>(entityName: "Category")
        
        //3
        do {
            categories = try getContext().fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Remove category Method
    func removeCategory(category: Category) {
        do {
            categories = getCategories()
            expenses = expensesHelper.getExpenses()
            for i in expenses {
                if i.category == category {
                    ExpensesHelper().removeExpenses(expense: i)
                }
            }
            getContext().delete(category)
            saveCategories()
            loadCategories()
        }
    }
    
    // MARK: Save categories
    func saveCategories() {
        do {
            try getContext().save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Get a context to work with CoreData by the method
    func getContext() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType) }
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }
    
    // Return an array of categories
    func getCategories() -> [Category] {
        loadCategories()
        return categories
    }
    
    func getTotalAmountOfCategory(category: Category) -> Double {
        var total: Double = 0.0
        let expenses = expensesHelper.getExpenses()
        for expense in expenses {
            if category == expense.category {
                total += expense.price
            }
        }
        
        return total
    }
}
