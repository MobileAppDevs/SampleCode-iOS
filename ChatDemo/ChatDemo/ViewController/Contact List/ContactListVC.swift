//
//  ContactListVC.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 27/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit
import Contacts

protocol contactDelegate{
    func selectContactwith(dict : Contact)
}

class ContactListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var arr_contact = [Contact]()
    var contactDelegate : contactDelegate!

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        
        FunctionConstants.getInstance().syncContacts { (contacts, error) in
            if error == nil{
                self.arr_contact = contacts!
                if self.arr_contact.count > 0{
                    self.arr_contact = self.arr_contact.sorted(by: { $0.name!.compare($1.name!) == .orderedAscending })
                    self.tableView.reloadData()
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension ContactListVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_contact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableCell", for: indexPath) as? ContactTableCell else {
            return UITableViewCell()
        }
        
        let dict = self.arr_contact[indexPath.row]
        
        cell.lbl_title.text = dict.firstLetter
        cell.lbl_name.text = dict.name
        
        /*let name = dict["contact_name"] as! String
        cell.lbl_name.text = dict["contact_name"] as? String
        cell.lbl_title.text = "\(String(describing: name.first!))"*/

        cell.view_color.backgroundColor = FunctionConstants.getInstance().randomColor()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arr_contact[indexPath.row]
        self.contactDelegate.selectContactwith(dict: dict)
        self.dismiss(animated: true, completion: nil)
    }
}

