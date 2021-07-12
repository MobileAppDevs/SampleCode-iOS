//
//  ViewController.swift
//  ContactList
//
//  Created by Ongraph on 12/07/21.
//

import UIKit
import Foundation
import Contacts

struct FetchedContact {
    var firstName: String
    var lastName: String
    var telephone: String
}

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    var contacts = [FetchedContact]()
    @IBOutlet weak var tableView: UITableView!
//    var contacts = [CNContact]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchContacts()
        // Do any additional setup after loading the view.
    }

    func fetchContacts() {
        
//        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
//        let request = CNContactFetchRequest(keysToFetch: keys)
//
//        let contactStore = CNContactStore()
//        do {
//            try contactStore.enumerateContacts(with: request) {
//                (contact, stop) in
//                // Array containing all unified contacts from everywhere
//                self.contacts.append(contact)
//            }
//        }
//        catch {
//            print("unable to fetch contacts")
//        }
//
//        self.tableView.reloadData()
        
        
        // 1.
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                // 2.
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    // 3.
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        self.contacts.append(FetchedContact(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
    
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2.
        // return the number of rows
        return contacts.count
    }

        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // 3.
        // Configure the cell...
            
//            cell.textLabel?.text = contacts[indexPath.row].givenName
            
        cell.textLabel?.text = contacts[indexPath.row].firstName + " " + contacts[indexPath.row].lastName
        cell.detailTextLabel?.text = contacts[indexPath.row].telephone

            return cell
    }

}

