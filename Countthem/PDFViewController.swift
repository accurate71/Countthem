//
//  PDFViewController.swift
//  Countthem
//
//  Created by Accurate on 18/06/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    var url: URL?
    
    let pdfView = PDFView(frame: CGRect.zero)
    
    let manager = PDFManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        if let url = url {
            
            setPDFView()
            
            let pdfDocument = PDFDocument(url: url)
            guard let doc = pdfDocument else { return }
            pdfView.document = doc
            
            let toolBar = createToolBar()
            
            self.view.addSubview(toolBar)
            self.view.addSubview(pdfView)
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": pdfView]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: .init(), metrics: nil, views: ["v0": toolBar]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1(50)]|", options: .init(), metrics: nil, views: ["v0": pdfView, "v1": toolBar]))
        } else {
            let viewMessage = UIView(frame: CGRect.zero)
            viewMessage.translatesAutoresizingMaskIntoConstraints = false
            let message = UILabel(frame: CGRect.zero)
            message.translatesAutoresizingMaskIntoConstraints = false
            message.text = NSLocalizedString("Something goes wrong, try again", comment: "Error message")
            message.adjustsFontSizeToFitWidth = true
            self.view.addSubview(viewMessage)
            viewMessage.addSubview(message)
            
            NSLayoutConstraint.activate([
                viewMessage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                viewMessage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                viewMessage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                viewMessage.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                message.centerYAnchor.constraint(equalTo: viewMessage.centerYAnchor),
                message.leadingAnchor.constraint(equalTo: viewMessage.leadingAnchor),
                message.trailingAnchor.constraint(equalTo: viewMessage.trailingAnchor)])
        }
    }
    
    @objc func dismissMethod(sender: UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func setPDFView() {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        pdfView.pageShadowsEnabled = true
        pdfView.displayMode = .singlePageContinuous
    }
    
    func createToolBar() -> UIToolbar {
        // Buttons
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(sender:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(delete(sender:)))
        //Toolbar
        let toolBar = UIToolbar(frame: CGRect.zero)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.setItems([shareButton, space, deleteButton], animated: true)
        
        return toolBar
    }
    
    @objc func share(sender: UIBarButtonItem) {
        if let url = url {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityVC, animated: true, completion: nil)
        }
    }
    
    @objc func delete(sender: UIBarButtonItem) {
        dismiss(animated: true) {
            self.manager.fileURL = nil
        }
    }

}
