//
//  CategoriesHelper.swift
//  Countthem
//
//  Created by Kirill Pushkarskiy.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//
/*
 The class is a manager of Categories. With the app, all the methods wired with categories are located here.
 The manager can save, delete, add, load categories.
 */
import Foundation
import UIKit
import CoreData

class CategoriesHelper {
    
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
            expenses = ExpensesHelper().getExpenses()
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
    
    func getContext() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType) }
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }
    
    func getCategories() -> [Category] {
        loadCategories()
        return categories
    }
}
