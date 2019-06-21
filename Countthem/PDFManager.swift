//
//  PDFManager.swift
//  Countthem
//
//  Created by Accurate on 18/06/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import Foundation
import SimplePDF
import UIKit

class PDFManager {
    let a4Size: CGSize = CGSize(width: 595, height: 842)
    var fileURL: URL?
    
    let expenseHelper = ExpensesHelper()
    let categoriesHelper = CategoriesHelper()
    
    func writePDF(title: String) {
        
        let pdf = SimplePDF(pageSize: a4Size, pageMargin: 20)
        let img = UIImage(named: "img_pdf")
        
        // Header
        createHeader(pdf: pdf)
        
        // Title and Image
        pdf.setContentAlignment(.center)
        pdf.addImage(img!)
        pdf.addLineSpace(20)
        pdf.setContentAlignment(.center)
        pdf.addText(title, font: UIFont.boldSystemFont(ofSize: 24), textColor: .black)
        pdf.addLineSpace(30)
        
        // Content
        let expenses = expenseHelper.getExpenses()
        let categories = categoriesHelper.getCategories()
        
        if !categories.isEmpty {
            pdf.setContentAlignment(.left)
            pdf.addText("Categories:", font: UIFont.boldSystemFont(ofSize: 20), textColor: .black)
            pdf.addLineSpace(10)
            
            for category in categories {
                pdf.addText(" -> \(category.name!)")
            }
            pdf.addLineSpace(20)
        }
        
        if !expenses.isEmpty {
            var count = 0
            pdf.setContentAlignment(.left)
            pdf.addText("Expenses:", font: UIFont.boldSystemFont(ofSize: 20), textColor: .black)
            pdf.addLineSpace(10)
            
            for expense in expenses {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                pdf.addText("\(formatter.string(from: expense.date!))", font: UIFont.boldSystemFont(ofSize: 18), textColor: .black)
                pdf.addText("Name: \(expense.name!) | Category: \(expense.category!.name!) | Price: \(expense.price)")
                pdf.addLineSpace(5)
                count += 1
                if count % 10 == 0 {
                    print("\(count)")
                    pdf.beginNewPage()
                    createHeader(pdf: pdf)
                }
            }
        }
        
        createPDF(pdf: pdf)
    }
    
    func createHeader(pdf: SimplePDF) {
        pdf.setContentAlignment(.left)
        pdf.addText("COUNTTHEM")
        pdf.addLineSeparator()
        pdf.addLineSpace(20)
    }
    
    private func createPDF(pdf: SimplePDF) {
        // Generate PDF data and save to a local file.
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            let fileName = "statistics.pdf"
            let documentsFileName = documentDirectories + "/" + fileName
            
            let pdfData = pdf.generatePDFdata()
            do{
                try pdfData.write(to: URL(fileURLWithPath: documentsFileName), options: .atomicWrite)
                fileURL = URL(fileURLWithPath: documentsFileName)
            }catch{
                print(error)
            }
        }
    }
    
    func getURL() -> URL? {
        return fileURL
    }
}
