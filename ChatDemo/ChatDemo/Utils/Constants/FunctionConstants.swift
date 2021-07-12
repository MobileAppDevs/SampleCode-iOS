//
//  FunctionConstants.swift
//  FirebaseChat
//
//  Created by Amit Chauhan on 21/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit
import Foundation
import Contacts

class FunctionConstants: NSObject {
    
    /*
     MARK: - Get Instance
     - Singleton Class
     */
    class func getInstance() -> FunctionConstants {
        struct Static {
            static let instance : FunctionConstants = FunctionConstants()
        }
        return Static.instance
    }
    
    
    //Get CurrentTimeStamp
    func GetCurrentTimeStamp() -> Double
    {
        let myTimeStamp = Date().timeIntervalSince1970
        let TimeStamp = Double(myTimeStamp) * 1000
        return TimeStamp
    }
    
    //Get Over View Date
    func GetDateFromTimestamp(TimeStamp:Double,DateFormat:String) -> String
    {
        let date = Date(timeIntervalSince1970:TimeStamp/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat
        return dateFormatter.string(from: date as Date)
    }
    
    /*
     MARK: - Trim
     */
    func trimString(str: String) -> String{
        return str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /*
     MARK: - Valid URL
     */
    func isValidUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    
    func syncContacts (completionBlock: @escaping ([Contact]?, NSError?) -> Void) ->Void{
               
               let store = CNContactStore()
               
               store.requestAccess(for: .contacts) { (isGranted, error) in
                   
                   // Check the isGranted flag and proceed if true
                   if isGranted == false {
                       return
                   }
                   
                   let contactStore = CNContactStore()
                   print("contactStore")
                   let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactFamilyNameKey, CNContactPhoneNumbersKey,CNContactEmailAddressesKey] as [Any]
                   
                   let request1 = CNContactFetchRequest(keysToFetch: keys  as! [CNKeyDescriptor])
                   var cnContacts = [CNContact]()
                   
                   try? contactStore.enumerateContacts(with: request1) { (contact, error) in
                       cnContacts.append(contact)
                   }

                var contacts = [Contact]()
                var tempDict = [String : Any]()

                   for contact in cnContacts {
                       let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                       
                       if fullName.isEmpty == false {
                           
                           for phoneNo in contact.phoneNumbers {
    //                           let number = (phoneNo.value ).stringValue
    //                           print("Phone Number: \(number)")
                               let numberValue = phoneNo.value
                               
                            tempDict["name"] = fullName
                            tempDict["email"] = ""
                            tempDict["countryCode"] = (numberValue.value(forKey: "countryCode") as? String)?.uppercased()
                            tempDict["number"] = numberValue.value(forKey: "digits") as? String
                            tempDict["firstLetter"] = "\(String(describing: fullName.first!))"

                            let conta = Contact.init(with: tempDict)
                            contacts.append(conta)
                            
                           }
                       }
                   }
                   completionBlock(contacts,nil)
               }
           }
    
    // returns a random color
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

