//
//  UserListVC.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 22/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit
import SDWebImage

class UserListVC: UIViewController {

    @IBOutlet weak var tableView            : UITableView!
    @IBOutlet weak var lblnoList            : UILabel!

    var arr_User                         :[User]?   = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userModel = UserDefaultManager.sharedInstance.getUserProfileModel()
        
        registerCell()
        
        FBDBManager.shared.getAllUser { [weak self] (arrUser) in
            self?.arr_User = arrUser
            if self?.arr_User?.count ?? 0 > 0{
                self?.tableView.isHidden = false
                self?.lblnoList.isHidden = true
                self?.tableView.reloadData()
            }else{
                self?.tableView.isHidden = true
                self?.lblnoList.isHidden = false
            }
        }
    }
    
    func registerCell(){
        let messageNib = UINib(nibName: "ListTableCell", bundle: nil)
        self.tableView.register(messageNib, forCellReuseIdentifier: "ListTableCell")
    }

    
//MARK:- Button Action
    @IBAction func btn_backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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


extension UserListVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_User?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as? ListTableCell else {
            return UITableViewCell()
        }
        self.tableView.tableFooterView = UIView()

        let dict = self.arr_User?[indexPath.row]
        cell.lblName.text = dict?.name
        cell.lblMessage.text = dict?.email
        
        if let imageUrl = dict?.image{
            cell.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.imgUser.sd_setImage(with:  URL(string: imageUrl), completed: nil)
        }else{
            cell.imgUser.image = UIImage(named: "ic_Default_Image")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.arr_User?[indexPath.row]
        let viewC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        viewC.receverId = data?.id ?? ""
        self.navigationController?.pushViewController(viewC, animated: true)
    }

}
