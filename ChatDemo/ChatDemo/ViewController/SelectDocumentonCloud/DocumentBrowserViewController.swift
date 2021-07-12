//
//  DocumentBrowserViewController.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 24/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit

protocol documentBrowserDelegate {
    func sendUrlForSelectedDocument(selectedUrl : URL)
}

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    var documentDelegate: documentBrowserDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = false
        allowsPickingMultipleItems = true

        
        let editButton   = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapEditButton(sender:)))
        
        // Update the style of the UIDocumentBrowserViewController
//         browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        additionalLeadingNavigationBarButtonItems = [editButton]
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   @objc func didTapEditButton(sender: UIBarButtonItem){
        debugPrint("cancel ****")
    
    self.dismiss(animated: true, completion: nil)
    }

    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        let newDocumentURL: URL? = nil
        
        // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
        // Make sure the importHandler is always called, even if the user cancels the creation request.
        if newDocumentURL != nil {
            importHandler(newDocumentURL, .move)
        } else {
            importHandler(nil, .none)
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        let success = sourceURL.startAccessingSecurityScopedResource()
        if success{
            self.dismiss(animated: true) {
                self.documentDelegate?.sendUrlForSelectedDocument(selectedUrl: sourceURL)
                sourceURL.stopAccessingSecurityScopedResource()
            }
            
//            self.dismiss(animated: true, completion: nil)
        }

       /* do {
            let data = try Data.init(contentsOf: sourceURL)
            print("data:\(data)")

        } catch let err {
            print("Error:\(err.localizedDescription)")
        }*/
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        documentDelegate?.sendUrlForSelectedDocument(selectedUrl: destinationURL)
        self.dismiss(animated: true, completion: nil)

    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        print("Error>>>:\(error?.localizedDescription)")
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
}

