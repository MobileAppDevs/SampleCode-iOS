//
//  RecentMessageListVC.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 22/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit
import SDWebImage

class RecentMessageListVC: UIViewController {
    
    @IBOutlet weak var tableView            : UITableView!
    @IBOutlet weak var lblNoChat            : UILabel!
    
    var arrChatList                         :[RecentMessage]?   = [RecentMessage]()
    
    var userData                                    : UserProfileModel?

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData = UserDefaultManager.sharedInstance.getUserProfileModel()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userModel = UserDefaultManager.sharedInstance.getUserProfileModel()
        
        registerCell()

        
        FBDBManager.shared.getAllRecentChatMessage(senderId: userModel?.uid ?? "") {[weak self] (arrMsg) in
            print("arrMsg >>", arrMsg)
            
            self?.arrChatList = arrMsg
            //print("arrMsg >>", arrMsg?[0].toDict)
            
            if self?.arrChatList?.count ?? 0 > 0{
                self?.tableView.reloadData()
                self?.tableView.isHidden = false
                self?.lblNoChat.isHidden = true
            }else{
                self?.tableView.isHidden = true
                self?.lblNoChat.isHidden = false
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

extension RecentMessageListVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChatList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as? ListTableCell else {
            return UITableViewCell()
        }
        tableView.tableFooterView = UIView()
        
        let data = self.arrChatList?[indexPath.row]
                
        if let name = data?.user?.name{
            cell.lblName.text = name
        }

        if data?.type == MessageType.text{
            if let msg = data?.text{
                cell.lblMessage.text = msg
            }
        }else if data?.type == MessageType.image{
            cell.lblMessage.text = "Photo"
        }else if data?.type == MessageType.location{
            cell.lblMessage.text = "Location"
        }else if data?.type == MessageType.video{
            cell.lblMessage.text = "Video"
        }else{
            cell.lblMessage.text = ""
        }
        
        
        if let imageUrl = data?.user?.image{
            cell.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.imgUser.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.arrChatList?[indexPath.row]
        let viewC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        viewC.receverId = data?.user?.id ?? ""
        self.navigationController?.pushViewController(viewC, animated: true)
    }
}
